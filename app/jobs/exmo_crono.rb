class ExmoCrono < ActiveJob::Base
  def perform
  	@data << Exmo::init
  end
end