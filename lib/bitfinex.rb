module Bitfinex


	def self.init
		@data = []
		data_array = [
			{parity: 'ETH_USD'},
			{parity: 'BTC_USD'},
			{parity: 'BCH_USD'},
			{parity: 'LTC_USD'},
			{parity: 'DSH_USD'},
			{parity: 'ETC_USD'},
			{parity: 'ZEC_USD'}
			
		]

		new_data = Array.new

		data_array.each do |d|
			parity = d[:parity].partition("_")
			parity1 = parity[0]
			parity2 = parity[2]
			value = Bitfinex::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		bitfinex_data = Bitfinexprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if bitfinex_data.save
			puts "###################### Successfully saved"
		end
		
		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'

		url = URI("https://api.bitfinex.com/v1/book/"+coin1+coin2+"?limit_bids=100&limit_asks=100")

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
		bitfinex = Bitfinexprice.last
		@data << Bitfinex::avg_price(bitfinex.eth[0], amount, bitfinex.eth[1], bitfinex.eth[2], bitfinex.eth[3])
		@data << Bitfinex::avg_price(bitfinex.btc[0], amount, bitfinex.btc[1], bitfinex.btc[2], bitfinex.btc[3])
		@data << Bitfinex::avg_price(bitfinex.bch[0], amount, bitfinex.bch[1], bitfinex.bch[2], bitfinex.bch[3])
		@data << Bitfinex::avg_price(bitfinex.ltc[0], amount, bitfinex.ltc[1], bitfinex.ltc[2], bitfinex.ltc[3])
		@data << Bitfinex::avg_price(bitfinex.dash[0], amount, bitfinex.dash[1], bitfinex.dash[2], bitfinex.dash[3])
		@data << Bitfinex::avg_price(bitfinex.etc[0], amount, bitfinex.etc[1], bitfinex.etc[2], bitfinex.etc[3])
		@data << Bitfinex::avg_price(bitfinex.zec[0], amount, bitfinex.zec[1], bitfinex.zec[2], bitfinex.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)

		
		if result != nil
			
			#Ask Calculation

			

			ask = Common::create_table(result['asks'].map(&:values))

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result['bids'].map(&:values))
			bid_avg = Common::calculate_avg_price(bid, money)

			


			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'Bitfinex', result
		return data
		end

	end
	
end

