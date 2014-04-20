require 'spec_helper'

describe 'handshake' do
  include VegaServer::HandshakeSteps
  let(:client) { 'client' }

  before { enable_modified_event }

  after do
    disable_modified_event
    stop_server
  end

  context 'allowed origins are configured' do
    let(:allowed_origins) { [allowed_origin] }
    let(:allowed_origin) { /example.org/ }

    before do
      configure_origins(allowed_origins)
      start_server
      open_socket(client, origin)
    end

    after { reset_allowed_origins }

    context 'origin of client is allowed' do
      let(:origin) { 'http://www.example.org' }

      it('leaves the connection open') do
        assert_socket_open(client)
      end
    end

    context 'origin of client is not allowed' do
      let(:origin) { 'http://www.example.com' }

      it 'closes the connection' do
        assert_socket_closed(client)
      end
    end
  end

  context 'allowed origins are not configured' do
    let(:origin) { 'http://www.example.com' }

    before do
      start_server
      open_socket(client, origin)
    end

    it 'leaves the connection open' do
      assert_socket_open(client)
    end
  end
end
