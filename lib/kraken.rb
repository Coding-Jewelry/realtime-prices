module Kraken
	def self.init
			@data = []
		data_array = [
			{parity: 'ETH_USD'},
			{parity: 'XBT_USD'},
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
			value = Kraken::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		kraken_data = Krakenprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if kraken_data.save
			puts "###################### Successfully saved"
		end
		
		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'
		url = URI("https://api.kraken.com/0/public/Depth?pair="+coin1+coin2+"&count=100")

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
		kraken = Krakenprice.last
		@data << Kraken::avg_price(kraken.eth[0], amount, kraken.eth[1], kraken.eth[2], kraken.eth[3])
		@data << Kraken::avg_price(kraken.btc[0], amount, kraken.btc[1], kraken.btc[2], kraken.btc[3])
		@data << Kraken::avg_price(kraken.bch[0], amount, kraken.bch[1], kraken.bch[2], kraken.bch[3])
		@data << Kraken::avg_price(kraken.ltc[0], amount, kraken.ltc[1], kraken.ltc[2], kraken.ltc[3])
		@data << Kraken::avg_price(kraken.dash[0], amount, kraken.dash[1], kraken.dash[2], kraken.dash[3])
		@data << Kraken::avg_price(kraken.etc[0], amount, kraken.etc[1], kraken.etc[2], kraken.etc[3])
		@data << Kraken::avg_price(kraken.zec[0], amount, kraken.zec[1], kraken.zec[2], kraken.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)

		
		if result != nil
			
			#Ask Calculation

		case coin1
			when 'BCH', 'DASH'
				result_val = result["result"][coin1+coin2]
			else
				result_val = result["result"]['X'+coin1+'Z'+coin2]
			end

			


			ask = Common::create_table(result_val['asks'])

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result_val['bids'])
			bid_avg = Common::calculate_avg_price(bid, money)

			


			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'Kraken', result
		return data
		end

	end
	
end







