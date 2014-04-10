module VegaServer
  module Storage
    class Memory
      def self.add_to_room(room_id, client_info)
        client_id = client_info.delete(:client_id)

        storage[room_id] = { client_id => client_info }
      end

      def self.storage
        @storage ||= {}
      end
    end
  end
end
