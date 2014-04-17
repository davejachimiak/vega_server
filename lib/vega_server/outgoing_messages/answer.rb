module VegaServer::OutgoingMessages
  class Answer
    include ClientMessageable

    def initialize(peer_id, answer)
      @peer_id = peer_id
      @answer  = answer
    end

    def type
      'answer'
    end

    def payload
      { answer: @answer, peerId: @peer_id }
    end
  end
end
