require 'spec_helper'

describe 'handshake' do
  include VegaServer::HandshakeSteps

  before { enable_modified_event }
  after { disable_modified_event }

  context 'allowed origins are configured' do
    let(:allowed_origins) { [allowed_origin] }
    let(:allowed_origin) { 'http://www.example.org' }

    before do
      configure_origins(allowed_origins)
      start_server
      open_socket(origin)
    end

    after do
      stop_server
      reset_allowed_origins
    end

    context 'origin of client is allowed' do
      let(:origin) { allowed_origin }

      it('leaves the connection open') { assert_socket_open }
    end

    context 'origin of client is not allowed' do
      let(:origin) { 'http://www.example.com' }

      it('closes the connection') { assert_socket_closed }
    end
  end

  context 'allowed origins are not configured' do
    let(:origin) { 'http://www.example.com' }

    before do
      start_server
      open_socket(origin)
    end

    it('leaves the connection open') { assert_socket_open }
  end
end
