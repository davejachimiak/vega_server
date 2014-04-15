module VegaServer::OutgoingMessages
  class Offer
    include ClientMessageable

    def initialize(peer_id, offer)
      @peer_id = peer_id
      @offer   = offer
    end

    def type
      'offer'
    end

    def payload
      { offer: @offer, peerId: @peer_id }
    end
  end
end
