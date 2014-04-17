module VegaServer
  module Storage
    class Memory
      def self.add_to_room(room_id, client_id, client_info)
        storage[room_id] ||= {}
        storage[room_id][client_id] = client_info
      end

      def self.room_is_empty?(room_id)
        !storage[room_id]
      end

      def self.room(room_id)
        storage[room_id]
      end

      def self.find(&block)
        storage.find(&block)
      end

      private

      def self.storage
        @storage ||= {}
      end
    end
  end
end
