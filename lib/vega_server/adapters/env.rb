require 'delegate'

module VegaServer
  module Adapters
    class Env < SimpleDelegator
      def origin
        self['HTTP_ORIGIN']
      end
    end
  end
end
