module VegaServer::OutgoingMessages
  class UnexpectedPeerHangUp
    include ClientMessageable

    def initialize(peer_id)
      @peer_id = peer_id
    end

    def type
      'unexpectedPeerHangUp'
    end

    def payload
      { peerId: @peer_id }
    end
  end
end
