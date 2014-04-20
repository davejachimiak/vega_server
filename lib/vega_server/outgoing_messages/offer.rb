module VegaServer::OutgoingMessages
  class Offer
    include ClientMessageable
    include VegaServer::Meddleable

    def initialize(peer_id, offer)
      @peer_id = peer_id
      @offer   = offer
    end

    def type
      'offer'
    end

    def payload
      { offer: @offer, peerId: @peer_id, peerBadge: peer_badge }
    end

    private

    def peer_badge
      storage.client(@peer_id)[:badge]
    end
  end
end
