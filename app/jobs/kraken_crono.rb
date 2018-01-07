class KrakenCrono < ActiveJob::Base
  def perform
  	@data << Kraken::init
  end
end