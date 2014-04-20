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
        if room_id = client_room_id(client_id)
          room(room_id)
        else
          []
        end
      end

      def self.remove_client(client_id)
        client_room(client_id).delete(client_id)

        if client_room(client_id).empty?
          room_id = client_room_id(client_id)
          rooms.delete(room_id)
        end

        clients.delete(client_id)
      end

      def self.room(room_id)
        rooms[room_id] || []
      end

      def self.client(client_id)
        clients[client_id]
      end

      private

      def self.client_room_id(client_id)
        if client = client(client_id)
          client[:room_id]
        end
      end

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
