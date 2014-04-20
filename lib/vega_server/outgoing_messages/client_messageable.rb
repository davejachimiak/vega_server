module VegaServer::OutgoingMessages
  module ClientMessageable
    def as_json
      VegaServer::Json.dump(as_hash)
    end

    def as_hash
      { type: type, payload: payload }
    end
  end
end
