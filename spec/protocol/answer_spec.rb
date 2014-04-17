require 'spec_helper'

describe 'answer message' do
  include VegaServer::MessageSteps

  let(:client_1) { 'client_1' }
  let(:client_2) { 'client_2' }
  let(:call_message) do
    MultiJson.dump({ type: 'call', payload: call_payload })
  end
  let(:call_payload) do
    { roomId: room_id,
      badge: badge }
  end
  let(:answer_message) do
    MultiJson.dump({ type: 'answer', payload: { answer: answer } })
  end
  let(:room_id) { '/chat/abc123' }
  let(:badge) { {} }
  let(:client_id) { 'yup' }
  let(:response) do
    MultiJson.dump({ type: 'answer', payload: response_payload })
  end
  let(:response_payload) { { answer: answer, peerId: client_id } }
  let(:answer) { { some: :stuff } }

  before do
    start_server
  end

  after { stop_server }

  it 'relays the answer to the client with the peerId' do
    open_socket(client_1)
    open_socket(client_2)
    add_listener(client_2)
    send_message(client_2, call_message)
    stub_client_id(client_id)
    send_message(client_1, call_message)

    send_message(client_1, answer_message)
    assert_response(client_2, response)
  end
end
