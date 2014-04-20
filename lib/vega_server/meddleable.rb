module VegaServer
  module Meddleable
    def pool
      VegaServer.connection_pool
    end

    def storage
      VegaServer.storage
    end
  end
end
