module VegaServer::OutgoingMessages
  class CallerSuccess
    include ClientMessageable

    def type
      'callerSuccess'
    end

    def payload
      {}
    end
  end
end
