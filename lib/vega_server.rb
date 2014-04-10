require 'vega_server/version'
require 'faye/websocket'
require 'vega_server/server'

module VegaServer
  def self.configure
    yield(self)
  end

  def self.allow_origins(origins)
    @allowed_origins = origins
  end

  def self.allowed_origins
    @allowed_origins ||= []
  end
end
