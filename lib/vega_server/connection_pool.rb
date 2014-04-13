module VegaServer
  class ConnectionPool
    def self.[](client_id)
      pool[client_id]
    end

    def self.add!(websocket)
      if client_id = inverted_pool[websocket]
        client_id
      else
        client_id = SecureRandom.uuid
        pool[client_id] = websocket
        client_id
      end
    end

    def self.pool
      @pool ||= {}
    end

    def self.inverted_pool
      pool.invert
    end
  end
end
