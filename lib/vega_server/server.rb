require 'faye/websocket'
require 'vega_server/events'
require 'vega_server/add_event_listener'

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
      
      Faye::WebSocket.new(env, nil, { ping: 10 }).tap do |websocket|
        AddEventListener.call(:open, Events::Open, websocket, origin)
        AddEventListener.call(:message, Events::Message, websocket, origin)
      end.rack_response
    end

    def log(string)
    end
  end
end
