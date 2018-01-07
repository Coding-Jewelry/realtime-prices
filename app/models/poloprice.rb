
class Poloprice < ActiveRecord::Base

	serialize :eth, JSON
	serialize :btc, JSON
	serialize :bch, JSON
	serialize :ltc, JSON
	serialize :dash, JSON
	serialize :etc, JSON
	serialize :zec, JSON
	
end
