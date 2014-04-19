module VegaServer::OutgoingMessages
  class Candidate
    include ClientMessageable

    def initialize(peer_id, candidate)
      @peer_id   = peer_id
      @candidate = candidate
    end

    def type
      'candidate'
    end

    def payload
      { candidate: @candidate, peerId: @peer_id }
    end
  end
end
