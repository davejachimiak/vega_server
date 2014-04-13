require 'delegate'

module VegaServer::Adapters
  class Event < SimpleDelegator
    def origin
      env['HTTP_ORIGIN']
    end

    def env
      current_target.env
    end
  end
end
