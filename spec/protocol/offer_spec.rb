require 'spec_helper'

describe 'offer message is received' do
  include VegaServer::MessageSteps

  let(:peer_1) { 'peer_1' }
  let(:peer_2) { 'peer_2' }
  let(:client_3) { 'client_3' }
  let(:offer_message) do
    MultiJson.dump({ type: 'offer', payload: { offer: offer } })
  end
  let(:call_message) do
    MultiJson.dump({ type: 'call', payload: call_payload })
  end
  let(:call_payload) do
    { roomId: room_id,
      clientTypes: client_types,
      acceptablePeerTypes: acceptable_peer_types,
      badge: badge }
  end
  let(:room_id) { '/chat/abc123' }
  let(:client_types) { ['any'] }
  let(:acceptable_peer_types) { ['any'] }
  let(:badge) { {} }
  let(:client_id) { 'yup' }
  let(:response) do
    MultiJson.dump({ type: 'offer', payload: response_payload })
  end
  let(:response_payload) do
    { offer: offer, peerId: client_id }
  end
  let(:offer) { { some: :stuff } }

  before do
    start_server
    open_socket(client_3)
    open_peer_socket(peer_1)
    open_peer_socket(peer_2)
    send_peer_message(peer_1, call_message)
    send_peer_message(peer_2, call_message)
    add_peer_listener(peer_1)
    add_peer_listener(peer_2)
    stub_client_id(client_id)
    send_message(client_3, call_message)
  end

  after { stop_server }

  it "relays the message to the client's peers" do
    send_message(client_3, offer_message)
    assert_peer_response(peer_1, response)
    assert_peer_response(peer_2, response)
  end
end
