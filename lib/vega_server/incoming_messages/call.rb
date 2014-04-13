require 'vega_server/outgoing_messages'

module VegaServer::IncomingMessages
  class Call
    def initialize(websocket, payload)
      @websocket = websocket
      @payload   = payload
      @room_id   = payload.delete(:room_id)
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage
      @client_id = @pool.add!(@websocket)
    end

    def handle
      VegaServer::OutgoingMessages.send_message(@websocket, message)
      add_client_to_room
    end

    def self.handle(websocket, payload)
      new(websocket, payload).handle
    end

    private

    def add_client_to_room
      if successful_call?
        @storage.add_to_room(@room_id, @client_id, @payload)
      end
    end

    def successful_call?
      room_is_empty? || peers_and_clients_match?
    end

    def message
      if room_is_empty?
        VegaServer::OutgoingMessages::CallerSuccess.new
      elsif peers_and_clients_match?
        VegaServer::OutgoingMessages::CalleeSuccess.new
      else
        VegaServer::OutgoingMessages::UnacceptablePeerTypeError.new
      end
    end

    def peers_and_clients_match?
      @peers_and_clients_match ||=
        begin
          return true unless room
          peers_are_acceptable? && client_is_acceptable?
        end
    end

    def peers_are_acceptable?
      room_first_peer_data[:client_types].any? do |client_type|
        @payload[:acceptable_peer_types].include?(client_type)
      end
    end

    def client_is_acceptable?
      room_first_peer_data[:acceptable_peer_types].any? do |acceptable_peer_type|
        @payload[:client_types].include?(acceptable_peer_type)
      end
    end

    def room_first_peer_data
      @room_first_peer_data ||= room.first.last
    end

    def room
      @storage.room(@room_id)
    end

    def room_is_empty?
      @room_is_emtpy ||= @storage.room_is_empty?(@room_id)
    end
  end
end
