module VegaServer
  class Server
    def initialize
      @allowed_origins = VegaServer.allowed_origins
      @env_adapter = lambda do |env|
        VegaServer.env_adapter.new(env)
      end
    end

    def call(env)
      env    = @env_adapter.(env)
      origin = env.origin
      ws     = Faye::WebSocket.new(env, nil, { ping: 10 })

      ws.on :open do
        if !origin_allowed?(origin)
          ws.close
          ws = nil
        end
      end

      ws.rack_response
    end

    def log(string)
    end

    private

    def origin_allowed?(origin)
      return true if @allowed_origins.empty?
      @allowed_origins.include?(origin)
    end
  end
end
