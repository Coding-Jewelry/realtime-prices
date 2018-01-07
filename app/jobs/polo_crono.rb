class PoloCrono < ActiveJob::Base
  def perform
  	@data << Polo::init
  end
end