require 'vega_server/version'
require 'faye/websocket'

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

  class Server
    attr_accessor :origin

    def call(env)
      origin = env['HTTP_ORIGIN'] || self.origin
      ws     = Faye::WebSocket.new(env, nil, { ping: 10 })

      ws.on :open do
        if !VegaServer.allowed_origins.include?(origin)
          ws.close
          ws = nil
        end
      end

      ws.rack_response
    end

    def log(_)
    end
  end
end
