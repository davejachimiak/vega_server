require 'vega_server/on_open'
require 'vega_server/on_message'

module VegaServer
  class Server
    def initialize
      @env_adapter = lambda do |env|
        VegaServer.env_adapter.new(env)
      end
    end

    def call(env)
      env    = @env_adapter.(env)
      origin = env.origin
      ws     = Faye::WebSocket.new(env, nil, { ping: 10 })

      VegaServer::OnOpen.call(ws, origin)
      VegaServer::OnMessage.call(ws)

      ws.rack_response
    end

    def log(string)
    end
  end
end
