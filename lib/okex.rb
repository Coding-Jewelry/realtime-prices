module Okex

	def self.init
		@data = []
		data_array = [
			{parity: 'ETH_USDT'},
			{parity: 'BTC_USDT'},
			{parity: 'BCH_USDT'},
			{parity: 'LTC_USDT'},
			{parity: 'DASH_USDT'},
			{parity: 'ETC_USDT'},
			{parity: 'ZEC_USDT'}
			
		]

		new_data = Array.new
		data_array.each do |d|
			parity = d[:parity].partition("_")
			parity1 = parity[0]
			parity2 = parity[2]
			value = Okex::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		okex_data = Okexprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if okex_data.save
			puts "###################### Successfully saved"
		end
		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'

			
		
		url = URI("https://www.okex.com/api/v1/depth.do?symbol="+coin1.downcase+'_'+coin2.downcase+"&size=100")

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
		okex = Okexprice.last
		@data << Okex::avg_price(okex.eth[0], amount, okex.eth[1], okex.eth[2], okex.eth[3])
		@data << Okex::avg_price(okex.btc[0], amount, okex.btc[1], okex.btc[2], okex.btc[3])
		@data << Okex::avg_price(okex.bch[0], amount, okex.bch[1], okex.bch[2], okex.bch[3])
		@data << Okex::avg_price(okex.ltc[0], amount, okex.ltc[1], okex.ltc[2], okex.ltc[3])
		@data << Okex::avg_price(okex.dash[0], amount, okex.dash[1], okex.dash[2], okex.dash[3])
		@data << Okex::avg_price(okex.etc[0], amount, okex.etc[1], okex.etc[2], okex.etc[3])
		@data << Okex::avg_price(okex.zec[0], amount, okex.zec[1], okex.zec[2], okex.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)
		
		if result != nil

			
			#Ask Calculation
			#Ask verileri ters geliyor.
			ask = Common::create_table(result['asks'].sort { |o1, o2| o1[0] <=> o2[0] })

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result['bids'])
			bid_avg = Common::calculate_avg_price(bid, money)

			


			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'Okex', result
		return data
		end

	end
	
end







