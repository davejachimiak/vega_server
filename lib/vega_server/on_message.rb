require 'multi_json'

module VegaServer
  class OnMessage
    def initialize(ws)
      @ws   = ws
      @pool = VegaServer.connection_pool
    end

    def call
      @ws.on :message do |event|
        data    = event.data
        message = MultiJson.load(data)

        client_id = SecureRandom.uuid
        @pool[client_id] = @ws
      end
    end

    def self.call(ws)
      new(ws).call
    end
  end
end
