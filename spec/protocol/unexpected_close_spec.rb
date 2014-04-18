require 'spec_helper'

describe 'unexpected close' do
  include VegaServer::MessageSteps
  include VegaServer::HandshakeSteps

  let(:client_1) { 'client_1' }
  let(:client_2) { 'client_2' }
  let(:client_3) { 'client_3' }
  let(:call_message) do
    MultiJson.dump({ type: 'call', payload: call_payload })
  end
  let(:call_payload) { { roomId: room_id, badge: badge } }
  let(:room_id) { '/chat/abc123' }
  let(:badge) { {} }
  let(:response) do
    MultiJson.dump({ type: 'unexpectedPeerHangUp', payload: response_payload })
  end
  let(:response_payload) { { peerId: client_1 } }

  before do
    start_server
    open_socket(client_1)
    open_socket(client_2)
    open_socket(client_3)
    send_message(client_2, call_message)
    send_message(client_3, call_message)
    add_listener(client_2)
    add_listener(client_3)
    stub_client_id(client_1)
    send_message(client_1, call_message)
  end

  after { stop_server }

  it 'sends an unexpected peer hang up message to the other clients' do
    close_socket(client_1)

    assert_response(client_2, response)
    assert_response(client_3, response)
  end

  it 'removes the client from the connection pool' do
    close_socket(client_1)

    refute_connection_in_pool
  end

  it 'removes the client from the room' do
    close_socket(client_1)

    refute_client_in_room(room_id, client_1)
  end
end
