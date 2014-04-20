module VegaServer::OutgoingMessages
  class CallAccepted
    include ClientMessageable

    def initialize(peer_ids)
      @peer_ids = peer_ids
    end

    def type
      'callAccepted'
    end

    def payload
      { peerIds: @peer_ids }
    end
  end
end
