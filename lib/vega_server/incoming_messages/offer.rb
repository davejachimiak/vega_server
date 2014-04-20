require 'vega_server/outgoing_messages/offer'

module VegaServer::IncomingMessages
  class Offer
    include Relayable

    def read_relayable
      payload[:offer]
    end

    def outgoing_message_class
      VegaServer::OutgoingMessages::Offer
    end
  end
end
