class BinanceCrono < ActiveJob::Base
  def perform
  	@data << Binance::init
  end
end