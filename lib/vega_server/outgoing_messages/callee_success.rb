module VegaServer::OutgoingMessages
  class CalleeSuccess
    include ClientMessageable

    def type
      'calleeSuccess'
    end

    def payload
      {}
    end
  end
end
