module Zb


	def self.init
		@data = []
		data_array = [
			{parity: 'ETH_USDT'},
			{parity: 'BTC_USDT'},
			{parity: 'BCC_USDT'},
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
			value = Zb::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		zb_data = Zbprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if zb_data.save
			puts "###################### Successfully saved"
		end

		return @data
	end


	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'

		url = URI("http://api.zb.com/data/v1/depth?market="+coin1.downcase+'_'+coin2.downcase+"&size=100")

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
				if !res["error"].nil?
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
		zb = Zbprice.last
		@data << Zb::avg_price(zb.eth[0], amount, zb.eth[1], zb.eth[2], zb.eth[3])
		@data << Zb::avg_price(zb.btc[0], amount, zb.btc[1], zb.btc[2], zb.btc[3])
		@data << Zb::avg_price(zb.bch[0], amount, zb.bch[1], zb.bch[2], zb.bch[3])
		@data << Zb::avg_price(zb.ltc[0], amount, zb.ltc[1], zb.ltc[2], zb.ltc[3])
		@data << Zb::avg_price(zb.dash[0], amount, zb.dash[1], zb.dash[2], zb.dash[3])
		@data << Zb::avg_price(zb.etc[0], amount, zb.etc[1], zb.etc[2], zb.etc[3])
		@data << Zb::avg_price(zb.zec[0], amount, zb.zec[1], zb.zec[2], zb.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)

		
		if result != nil
			
			#Ask Calculation

			

			ask = Common::create_table(result['asks'].sort { |o1, o2| o1[0] <=> o2[0] })

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(result['bids'])
			bid_avg = Common::calculate_avg_price(bid, money)

			


			data = ask, ask_avg, bid, bid_avg, parity, coin1, coin2, 'Zb', result
		return data
		end

	end
	
end

