module VegaServer
  module Storage
    class Memory
      CLIENTS = :clients.freeze
      ROOMS   = :rooms.freeze

      def self.add_to_room(client_id, client_info)
        clients[client_id] = client_info

        room_id = client_info[:room_id]

        rooms[room_id] ||= []
        rooms[room_id].push(client_id)
      end

      def self.client_room(client_id)
        room_id = clients[client_id][:room_id]

        rooms[room_id]
      end

      def self.room_is_empty?(room_id)
        !rooms[room_id]
      end

      def self.room(room_id)
        rooms[room_id]
      end

      private

      def self.clients
        storage[CLIENTS] ||= {}
      end

      def self.rooms
        storage[ROOMS] ||= {}
      end

      def self.storage
        @storage ||= {}
      end
    end
  end
end
