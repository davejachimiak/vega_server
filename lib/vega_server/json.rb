require 'multi_json'
require 'active_support/inflector'

module VegaServer
  class Json
    def self.dump(hash)
      MultiJson.dump(hash)
    end

    def self.to_struct(json)
      hash          = load(json)
      purified_hash = purify_keys(hash)

      OpenStruct.new(purified_hash)
    end

    def self.load(json)
      MultiJson.load(json)
    rescue MultiJson::ParseError
      {}
    end

    def self.purify_keys(hash)
      return {} unless hash.is_a?(Hash)

      Hash[hash.map do |k, v|
        key   = k.underscore.to_sym
        value = v.is_a?(Hash) ? purify_keys(v) : v

        [key, value]
      end]
    end
  end
end
