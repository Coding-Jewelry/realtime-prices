module Binance

	def self.init
		@data = []
		data_array = [
			{parity: 'ETH_USDT'},
			{parity: 'BTC_USDT'},
			{parity: 'BCC_USDT'},
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
			value = Binance::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		binance_data = Binanceprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if binance_data.save
			puts "###################### Successfully saved"
		end

		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'

		
		url = URI("https://www.binance.com/api/v1/depth?symbol="+coin1+coin2+"&limit=100")

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
		binance = Binanceprice.last
		@data << Binance::avg_price(binance.eth[0], amount, binance.eth[1], binance.eth[2], binance.eth[3])
		@data << Binance::avg_price(binance.btc[0], amount, binance.btc[1], binance.btc[2], binance.btc[3])
		@data << Binance::avg_price(binance.bch[0], amount, binance.bch[1], binance.bch[2], binance.bch[3])
		@data << Binance::avg_price(binance.ltc[0], amount, binance.ltc[1], binance.ltc[2], binance.ltc[3])
		@data << Binance::avg_price(binance.dash[0], amount, binance.dash[1], binance.dash[2], binance.dash[3])
		@data << Binance::avg_price(binance.etc[0], amount, binance.etc[1], binance.etc[2], binance.etc[3])
		@data << Binance::avg_price(binance.zec[0], amount, binance.zec[1], binance.zec[2], binance.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)

		
		if result != nil
			
			#Ask Calculation

			ask = Common::create_table(result['asks'])

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result['bids'])
			bid_avg = Common::calculate_avg_price(bid, money)

			


			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'Binance', result
		return data
		end

	end
	
end







