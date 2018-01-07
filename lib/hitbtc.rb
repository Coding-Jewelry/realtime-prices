module Hitbtc

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
			value = Hitbtc::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		hitbtc_data = Hitbtcprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if hitbtc_data.save
			puts "###################### Successfully saved"
		end

		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'
		url = URI("https://api.hitbtc.com/api/2/public/orderbook/"+coin1+coin2+"?limit=100")

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
		hitbtc = Hitbtcprice.last
		@data << Hitbtc::avg_price(hitbtc.eth[0], amount, hitbtc.eth[1], hitbtc.eth[2], hitbtc.eth[3])
		@data << Hitbtc::avg_price(hitbtc.btc[0], amount, hitbtc.btc[1], hitbtc.btc[2], hitbtc.btc[3])
		@data << Hitbtc::avg_price(hitbtc.bch[0], amount, hitbtc.bch[1], hitbtc.bch[2], hitbtc.bch[3])
		@data << Hitbtc::avg_price(hitbtc.ltc[0], amount, hitbtc.ltc[1], hitbtc.ltc[2], hitbtc.ltc[3])
		@data << Hitbtc::avg_price(hitbtc.dash[0], amount, hitbtc.dash[1], hitbtc.dash[2], hitbtc.dash[3])
		@data << Hitbtc::avg_price(hitbtc.etc[0], amount, hitbtc.etc[1], hitbtc.etc[2], hitbtc.etc[3])
		@data << Hitbtc::avg_price(hitbtc.zec[0], amount, hitbtc.zec[1], hitbtc.zec[2], hitbtc.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)
		
		if result != nil
			
			#Ask Calculation

			ask = Common::create_table(result['ask'].map(&:values))

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result['bid'].map(&:values))
			bid_avg = Common::calculate_avg_price(bid, money)

			


			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'HitBtc', result
		return data
		end

	end
	
end







