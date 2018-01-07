
class BittrexCrono < ActiveJob::Base
  def perform
  	@data << Bittrex::init
  end
end