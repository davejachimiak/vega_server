require 'delegate'

module VegaServer
  module Adapters
    class ModifiedEnv < SimpleDelegator
      class << self
        attr_accessor :origin
      end

      def origin
        self.class.origin
      end
    end
  end
end
