class OkexCrono < ActiveJob::Base
  def perform
  	@data << Okex::init
  end
end