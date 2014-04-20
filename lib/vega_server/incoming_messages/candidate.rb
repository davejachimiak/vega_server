require 'vega_server/outgoing_messages/candidate'

module VegaServer::IncomingMessages
  class Candidate
    include Relayable

    def read_relayable
      payload[:candidate]
    end

    def outgoing_message_class
      VegaServer::OutgoingMessages::Candidate
    end
  end
end
