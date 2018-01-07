class ZbCrono < ActiveJob::Base
  def perform
  	@data << Zb::init
  end
end