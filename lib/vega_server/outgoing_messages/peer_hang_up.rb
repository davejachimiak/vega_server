module VegaServer::OutgoingMessages
  class PeerHangUp
    include ClientMessageable

    def initialize(peer_id)
      @peer_id = peer_id
    end

    def type
      'peerHangUp'
    end

    def payload
      { peerId: @peer_id }
    end
  end
end
