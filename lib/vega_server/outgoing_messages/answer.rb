module VegaServer::OutgoingMessages
  class Answer
    include ClientMessageable
    include VegaServer::Meddleable

    def initialize(peer_id, answer)
      @peer_id = peer_id
      @answer  = answer
    end

    def type
      'answer'
    end

    def payload
      { answer: @answer, peerId: @peer_id, peerBadge: peer_badge }
    end

    private

    def peer_badge
      storage.client(@peer_id)[:badge]
    end
  end
end
