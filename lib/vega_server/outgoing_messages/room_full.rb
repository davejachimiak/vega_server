module VegaServer::OutgoingMessages
  class RoomFull
    include ClientMessageable

    def type
      'roomFull'
    end

    def payload
      {}
    end
  end
end
