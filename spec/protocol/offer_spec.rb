require 'spec_helper'

describe 'offer message is received' do
  include VegaServer::MessageSteps

  let(:client_1) { 'client_1' }
  let(:client_2) { 'client_2' }
  let(:call_message) do
    MultiJson.dump({ type: 'call', payload: call_payload })
  end
  let(:call_payload) { { roomId: room_id, badge: badge } }
  let(:offer_message) do
    MultiJson.dump({ type: 'offer',
                     payload: { offer: offer, peerId: client_2 } })
  end
  let(:room_id) { '/chat/abc123' }
  let(:badge) { { user_id: 'fontana'} }
  let(:response) do
    MultiJson.dump({ type: 'offer', payload: response_payload })
  end
  let(:response_payload) { { offer: offer, peerId: client_1, peerBadge: badge } }
  let(:offer) { { some: :stuff } }

  before do
    start_server
    open_socket(client_1)
    open_socket(client_2)
    stub_client_id(client_2)
    send_message(client_2, call_message)
    add_listener(client_2)
    stub_client_id(client_1)
    send_message(client_1, call_message)
  end

  after { stop_server }

  it "relays the message to the client's peers" do
    send_message(client_1, offer_message)
    assert_response(client_2, response)
  end
end
