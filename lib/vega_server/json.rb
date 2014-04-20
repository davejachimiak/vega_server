require 'multi_json'
require 'active_support/inflector'

module VegaServer
  class Json
    def self.dump(hash)
      MultiJson.dump(hash)
    end

    def self.to_struct(json)
      converted     = load(json)
      hash          = enforce_hash(converted)
      purified_hash = purify_keys(hash)

      OpenStruct.new(purified_hash)
    end

    def self.load(json)
      MultiJson.load(json)
    rescue MultiJson::ParseError
      nil
    end

    def self.enforce_hash(object)
      object.is_a?(Hash) ? object : Hash.new
    end

    def self.purify_keys(hash)
      Hash[hash.map do |k, v|
        key   = k.underscore.to_sym
        value = v.is_a?(Hash) ? purify_keys(v) : v

        [key, value]
      end]
    end
  end
end
