module VegaServer::OutgoingMessages
  class Send
    def self.call(websocket, message)
      websocket.send(message.as_json)
    end
  end
end
