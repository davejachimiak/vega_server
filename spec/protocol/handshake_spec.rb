require 'spec_helper'

describe 'handshake' do
  include VegaSteps

  context 'allowed origins are configured' do
    context 'origin of client is allowed' do
      it 'leaves the connection open' do
        #VegaServer.configure do |config|
          #config.allow_origins(["http://www.example.com"])
        #end
        start_server
        open_socket

        assert_socket_open

        stop_server
      end
    end

    context 'origin of client is not allowed' do
      it 'closes the connection'
    end
  end
end
