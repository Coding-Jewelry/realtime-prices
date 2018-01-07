class BitfinexCrono < ActiveJob::Base
  def perform
  	@data << Bitfinex::init
  end
end