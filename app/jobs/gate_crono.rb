class GateCrono < ActiveJob::Base
  def perform
  	@data << Gate::init
  end
end