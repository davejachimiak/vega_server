module VegaServer::OutgoingMessages
  class RoomFullError
    include ClientMessageable

    def type
      'roomFullError'
    end

    def payload
      {}
    end
  end
end
