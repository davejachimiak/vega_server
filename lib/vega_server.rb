require 'vega_server/version'
require 'faye/websocket'
require 'vega_server/server'
require 'vega_server/adapters'

module VegaServer
  def self.configure
    yield(self)
  end

  def self.allow_origins(origins)
    @allowed_origins = origins
  end

  def self.allowed_origins
    @allowed_origins ||= []
  end

  def self.env_adapter
    @env_adapter ||= VegaServer::Adapters::Env
  end

  def self.enable_modified_env!
    @env_adapter = VegaServer::Adapters::ModifiedEnv
  end

  def self.disable_modified_env!
    @env_adapter = VegaServer::Adapters::Env
  end

  def self.connection_pool
    @connection_pool ||= {}
  end
end
