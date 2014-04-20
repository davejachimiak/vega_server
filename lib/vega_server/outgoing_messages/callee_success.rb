module VegaServer::OutgoingMessages
  class CalleeSuccess
    include ClientMessageable

    def initialize(peer_ids)
      @peer_ids = peer_ids
    end

    def type
      'calleeSuccess'
    end

    def payload
      { peerIds: @peer_ids }
    end
  end
end
