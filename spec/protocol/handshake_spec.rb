require 'spec_helper'

describe 'handshake' do
  include VegaServer::HandshakeSteps

  context 'allowed origins are configured' do
    let(:allowed_origins) { [allowed_origin] }
    let(:allowed_origin) { 'http://www.example.org' }

    before { configure_origins(allowed_origins) }

    context 'origin of client is allowed' do
      it 'leaves the connection open' do
        start_server
        open_socket(allowed_origin)

        assert_socket_open

        stop_server
      end
    end

    context 'origin of client is not allowed' do
      let(:bad_origin) { 'http://www.example.com' }

      it 'closes the connection' do
        start_server
        open_socket(bad_origin)

        assert_socket_closed

        stop_server
      end
    end
  end
end
