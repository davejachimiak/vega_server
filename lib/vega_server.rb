require 'vega_server/version'
require 'faye/websocket'

module VegaServer
  class Server
    def call(env)
      ws = Faye::WebSocket.new(env, nil, { ping: 10 })
      ws.rack_response
    end

    def log(_)
    end
  end
end
