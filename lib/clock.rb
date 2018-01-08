
require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

module Clockwork

	handler do |job|
	    puts "Running #{job}"
	end

	every(2.minutes, 'job ­ Inserting Record in DB') { 
		Binance::init
		Bitfinex::init
		Bittrex::init
		Exmo::init
		Gate::init
		Hitbtc::init
		Kraken::init
		Okex::init
		Polo::init
		Zb::init
	}

end