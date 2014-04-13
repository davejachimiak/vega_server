module VegaServer::OutgoingMessages
  class UnacceptablePeerTypeError
    include ClientMessageable

    def type
      'unacceptablePeerTypeError'
    end

    def payload
      {}
    end
  end
end
