class HitbtcCrono < ActiveJob::Base
  def perform
  	@data << Hitbtc::init
  end
end