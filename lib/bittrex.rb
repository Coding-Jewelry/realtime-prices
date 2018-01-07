
# require "#{Rails.root}/app/models/bittrex_price.rb"

module Bittrex

	def self.init
		@data = []
		data_array = [
			{parity: 'USDT_ETH'},
			{parity: 'USDT_BTC'},
			{parity: 'USDT_BCC'},
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
			value = Bittrex::get_pair_orderbook(parity1, parity2)
			new_data << value
		end

		bittrex_data = Bittrexprice.new(:eth=>new_data[0], :btc=>new_data[1], :bch=>new_data[2], :ltc=>new_data[3], :dash=>new_data[4], :etc=>new_data[5], :zec=>new_data[6])
		if bittrex_data.save
			puts "###################### Successfully saved"
		end

		return @data
	end

	def self.get_pair_orderbook(coin1, coin2)
		#sleep(1.second)
		require 'uri'
		require 'net/http'
		
		url = URI("https://bittrex.com/api/v1.1/public/getorderbook?market="+coin1+'-'+coin2+"&type=both")

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
		bittrex = Bittrexprice.last
		@data << Bittrex::avg_price(bittrex.eth[0], amount, bittrex.eth[1], bittrex.eth[2], bittrex.eth[3])
		@data << Bittrex::avg_price(bittrex.btc[0], amount, bittrex.btc[1], bittrex.btc[2], bittrex.btc[3])
		@data << Bittrex::avg_price(bittrex.bch[0], amount, bittrex.bch[1], bittrex.bch[2], bittrex.bch[3])
		@data << Bittrex::avg_price(bittrex.ltc[0], amount, bittrex.ltc[1], bittrex.ltc[2], bittrex.ltc[3])
		@data << Bittrex::avg_price(bittrex.dash[0], amount, bittrex.dash[1], bittrex.dash[2], bittrex.dash[3])
		@data << Bittrex::avg_price(bittrex.etc[0], amount, bittrex.etc[1], bittrex.etc[2], bittrex.etc[3])
		@data << Bittrex::avg_price(bittrex.zec[0], amount, bittrex.zec[1], bittrex.zec[2], bittrex.zec[3])
	end

	def self.avg_price(result, money, parity, coin1, coin2)

		
		if result != nil
			
			#Ask Calculation


			r_sell = ((result['result']['sell']).each{|v| v.replace({"Rate" => v.delete("Rate")}.merge(v))}).map(&:values)
			r_buy = ((result['result']['buy']).each{|v| v.replace({"Rate" => v.delete("Rate")}.merge(v))}).map(&:values)


			ask = Common::create_table(r_sell)

			ask_avg = Common::calculate_avg_price(ask, money)
			
			#Bid Calculation
			bid = Common::create_table(r_buy)
			bid_avg = Common::calculate_avg_price(bid, money)

			data = ask, ask_avg, bid, bid_avg, parity, coin2, coin1, 'Bittrex', result
		return data
		end

	end
	
end







