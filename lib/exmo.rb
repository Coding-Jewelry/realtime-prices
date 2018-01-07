module Exmo

	def self.init
		@data = []
		data_array = [
			{parity: 'ETH_USD'},
			{parity: 'BTC_USD'},
			{parity: 'BCH_USD'},
			{parity: 'LTC_USD'},
			{parity: 'DASH_USD'},
			{parity: 'ETC_USD'},
			{parity: 'ZEC_USD'}	
		]

		new_data = Array.new

		data_array.each do |d|
			parity = d[:parity].partition("_")
			parity1 = parity[0]
			parity2 = parity[2]
			value = Exmo::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		exmo_data = Exmoprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if exmo_data.save
			puts "###################### Successfully saved"
		end

		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'
		url = URI("https://api.exmo.com/v1/order_book/?pair="+coin1+'_'+coin2+"&limit=100")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true

		request = Net::HTTP::Get.new(url)

		
		begin
  			response = http.request(request)
		rescue StandardError
  			false
		end

		if !response.nil? && response.code == '200'
			order_book = JSON.parse(response.body)
		else
			order_book = nil
		end

		parity = coin1 + "_" +coin2	
		return order_book, parity, coin1, coin2
	end

	def self.get_all_prices(amount)
		@data = []
		exmo = Exmoprice.last
		@data << Exmo::avg_price(exmo.eth[0], amount, exmo.eth[1], exmo.eth[2], exmo.eth[3])
		@data << Exmo::avg_price(exmo.btc[0], amount, exmo.btc[1], exmo.btc[2], exmo.btc[3])
		@data << Exmo::avg_price(exmo.bch[0], amount, exmo.bch[1], exmo.bch[2], exmo.bch[3])
		@data << Exmo::avg_price(exmo.ltc[0], amount, exmo.ltc[1], exmo.ltc[2], exmo.ltc[3])
		@data << Exmo::avg_price(exmo.dash[0], amount, exmo.dash[1], exmo.dash[2], exmo.dash[3])
		@data << Exmo::avg_price(exmo.etc[0], amount, exmo.etc[1], exmo.etc[2], exmo.etc[3])
		@data << Exmo::avg_price(exmo.zec[0], amount, exmo.zec[1], exmo.zec[2], exmo.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)
		
		if result != nil
			
			#Ask Calculation


			ask = Common::create_table(result[parity]['ask'])
			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result[parity]['bid'])
			bid_avg = Common::calculate_avg_price(bid, money)




			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'Exmo', result


		return data
		end

	end
	
end







