require 'spec_helper'

describe 'handshake' do
  include VegaServer::HandshakeSteps

  context 'allowed origins are configured' do
    context 'origin of client is allowed' do
      let(:origins) { ['http://www.example.org'] }
      #before { configure_origins(origins) }

      it 'leaves the connection open' do
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
