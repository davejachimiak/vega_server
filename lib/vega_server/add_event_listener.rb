module VegaServer
  class AddEventListener
    def self.call(type, handler, websocket, origin)
      websocket.on(type) do |event|
        handler.handle(websocket, event, origin)
      end
    end
  end
end
