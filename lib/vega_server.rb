require 'vega_server/version'
require 'faye/websocket'

module VegaServer
  def self.configure
    yield(self)
  end

  def self.allow_origins(huh)
  end

  class Server
    def call(env)
      ws = Faye::WebSocket.new(env, nil, { ping: 10 })
      ws.rack_response
    end

    def log(_)
    end
  end
end
