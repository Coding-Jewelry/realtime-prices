
class MainController < ApplicationController
	def index

	end


	def get_data

		amount = params[:amount].to_i
		@data = []
		if amount == 0
			@data << {error: 'Invalid value!'}
		else
			
			coin_list = ["ETH", "BTC", "BCH", "LTC", "DASH", "ETC", "ZEC"]
			
			@data << coin_list

			@data << Hitbtc::get_all_prices(amount)
			@data << Polo::get_all_prices(amount)
			@data << Exmo::get_all_prices(amount)
			@data << Okex::get_all_prices(amount)
			@data << Bittrex::get_all_prices(amount)
			@data << Kraken::get_all_prices(amount)
			@data << Bitfinex::get_all_prices(amount)
			@data << Binance::get_all_prices(amount)
			@data << Zb::get_all_prices(amount)
			@data << Gate::get_all_prices(amount)

		end
		render :json => @data
	end
end
