require 'spec_helper'

describe 'offer message is received' do
  include VegaServer::MessageSteps

  let(:client_1) { 'client_1' }
  let(:client_2) { 'client_2' }
  let(:client_3) { 'client_3' }
  let(:call_message) do
    MultiJson.dump({ type: 'call', payload: call_payload })
  end
  let(:call_payload) { { roomId: room_id, badge: badge } }
  let(:offer_message) do
    MultiJson.dump({ type: 'offer', payload: { offer: offer } })
  end
  let(:room_id) { '/chat/abc123' }
  let(:badge) { {} }
  let(:client_id) { 'yup' }
  let(:response) do
    MultiJson.dump({ type: 'offer', payload: response_payload })
  end
  let(:response_payload) { { offer: offer, peerId: client_id } }
  let(:offer) { { some: :stuff } }

  before do
    start_server
    open_socket(client_1)
    open_socket(client_2)
    open_socket(client_3)
    send_message(client_2, call_message)
    send_message(client_3, call_message)
    add_listener(client_2)
    add_listener(client_3)
    stub_client_id(client_id)
    send_message(client_1, call_message)
  end

  after { stop_server }

  it "relays the message to the client's peers" do
    send_message(client_1, offer_message)
    assert_response(client_2, response)
    assert_response(client_3, response)
  end
end
