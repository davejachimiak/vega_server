require 'vega_server/on_open'

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

      ws.rack_response
    end

    def log(string)
    end
  end
end
