require 'delegate'

module VegaServer::Adapters
  class Env < SimpleDelegator
    def origin
      self['HTTP_ORIGIN']
    end
  end
end
