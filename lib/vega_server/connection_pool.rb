module VegaServer
  class ConnectionPool
    def self.[](client_id)
      pool[client_id]
    end

    def self.add!(websocket)
      inverted_pool.fetch(websocket) do |websocket|
        client_id = SecureRandom.uuid
        pool[client_id] = websocket
        client_id
      end
    end

    def self.delete(client_id)
      pool.delete(client_id)
    end

    def self.pool
      @pool ||= {}
    end

    def self.inverted_pool
      pool.invert
    end
  end
end
