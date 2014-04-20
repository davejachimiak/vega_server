module VegaServer::IncomingMessages
  class Factory
    CALL      = 'call'.freeze
    OFFER     = 'offer'.freeze
    ANSWER    = 'answer'.freeze
    CANDIDATE = 'candidate'.freeze
    HANG_UP   = 'hangUp'.freeze

    def self.create(websocket, type, payload)
      case type
      when CALL
        VegaServer::IncomingMessages::Call.new(websocket, payload)
      when OFFER
        VegaServer::IncomingMessages::Offer.new(websocket, payload)
      when ANSWER
        VegaServer::IncomingMessages::Answer.new(websocket, payload)
      when CANDIDATE
        VegaServer::IncomingMessages::Candidate.new(websocket, payload)
      when HANG_UP
        VegaServer::IncomingMessages::HangUp.new(websocket)
      else
        VegaServer::IncomingMessages::Null.new
      end
    end
  end
end
