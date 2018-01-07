module Polo

	def self.init
		@data = []
		data_array = [
			{parity: 'USDT_ETH'},
			{parity: 'USDT_BTC'},
			{parity: 'USDT_BCH'},
			{parity: 'USDT_LTC'},
			{parity: 'USDT_DASH'},
			{parity: 'USDT_ETC'},
			{parity: 'USDT_ZEC'}	
			
		]

		new_data = Array.new

		data_array.each do |d|
			parity = d[:parity].partition("_")
			parity1 = parity[0]
			parity2 = parity[2]
			value = Polo::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		polo_data = Poloprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if polo_data.save
			puts "###################### Successfully saved"
		end

		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'
		url = URI("https://poloniex.com/public?command=returnOrderBook&currencyPair="+coin1+'_'+coin2+"&depth=100")

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
		polo = Poloprice.last
		@data << Polo::avg_price(polo.eth[0], amount, polo.eth[1], polo.eth[2], polo.eth[3])
		@data << Polo::avg_price(polo.btc[0], amount, polo.btc[1], polo.btc[2], polo.btc[3])
		@data << Polo::avg_price(polo.bch[0], amount, polo.bch[1], polo.bch[2], polo.bch[3])
		@data << Polo::avg_price(polo.ltc[0], amount, polo.ltc[1], polo.ltc[2], polo.ltc[3])
		@data << Polo::avg_price(polo.dash[0], amount, polo.dash[1], polo.dash[2], polo.dash[3])
		@data << Polo::avg_price(polo.etc[0], amount, polo.etc[1], polo.etc[2], polo.etc[3])
		@data << Polo::avg_price(polo.zec[0], amount, polo.zec[1], polo.zec[2], polo.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)
		
		if result != nil
			
			#Ask Calculation



			ask = Common::create_table(result['asks'])


			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result['bids'])
			bid_avg = Common::calculate_avg_price(bid, money)

			

			#Polo'da coinler ters
			data = ask, ask_avg, bid, bid_avg, parity, coin2, coin1, 'Polo', result
		return data
		end

	end
	
end







