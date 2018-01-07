module Gate


	def self.init
		@data = []
		data_array = [
			{parity: 'ETH_USDT'},
			{parity: 'BTC_USDT'},
			{parity: 'BCH_USDT'},
			{parity: 'LTC_USDT'},
			{parity: 'DSH_USDT'},
			{parity: 'ETC_USDT'},
			{parity: 'ZEC_USDT'}
			
		]

		new_data = Array.new

		data_array.each do |d|
			parity = d[:parity].partition("_")
			parity1 = parity[0]
			parity2 = parity[2]
			value = Gate::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		gate_data = Gateprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if gate_data.save
			puts "###################### Successfully saved"
		end

		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'

		url = URI("http://data.gate.io/api2/1/orderBook/"+coin1.downcase+'_'+coin2.downcase)

		http = Net::HTTP.new(url.host, url.port)
		#http.use_ssl = true

		request = Net::HTTP::Get.new(url)

		
		begin
  			response = http.request(request)
		rescue StandardError
  			false
		end




		if !response.nil? && response.code == '200'
			res = JSON.parse(response.body)
				if res["result"] == "false"
					order_book = nil
				else
					order_book = res
				end
		else
			order_book = nil
		end

		parity = coin1 + "_" +coin2	
		return order_book, parity, coin1, coin2
	end

	def self.get_all_prices(amount)
		@data = []
		gate = Gateprice.last
		@data << Gate::avg_price(gate.eth[0], amount, gate.eth[1], gate.eth[2], gate.eth[3])
		@data << Gate::avg_price(gate.btc[0], amount, gate.btc[1], gate.btc[2], gate.btc[3])
		@data << Gate::avg_price(gate.bch[0], amount, gate.bch[1], gate.bch[2], gate.bch[3])
		@data << Gate::avg_price(gate.ltc[0], amount, gate.ltc[1], gate.ltc[2], gate.ltc[3])
		@data << Gate::avg_price(gate.dash[0], amount, gate.dash[1], gate.dash[2], gate.dash[3])
		@data << Gate::avg_price(gate.etc[0], amount, gate.etc[1], gate.etc[2], gate.etc[3])
		@data << Gate::avg_price(gate.zec[0], amount, gate.zec[1], gate.zec[2], gate.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)

		
		if result != nil
			
			#Ask Calculation

			

			ask = Common::create_table(result['asks'].sort { |o1, o2| o1[0] <=> o2[0] })

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result['bids'])
			bid_avg = Common::calculate_avg_price(bid, money)

			


			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'Gate', result
		return data
		end

	end
	
end

