module VegaServer
  class AddEventListener
    def self.call(type, handler, websocket)
      websocket.on(type) do |event|
        handler.handle(websocket, event)
      end
    end
  end
end
