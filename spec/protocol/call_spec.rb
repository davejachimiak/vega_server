require 'spec_helper'
require 'multi_json'

describe 'call message is received' do
  include VegaServer::CallMessageSteps

  let(:message) { MultiJson.dump(raw_message) }
  let(:raw_message) { { type: 'call', payload: payload } }
  let(:payload) do
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

  before do
    start_server
    open_socket
    stub_client_id(client_id)
  end

  after { stop_server }

  shared_examples_for 'call message' do
    it 'adds the connection to the pool' do
      send_message(message)
      assert_connection_in_pool
    end
  end

  shared_examples_for 'successful call message' do
    it_should_behave_like 'call message'

    it 'adds the client to the room' do
      send_message(message)

      assert_client_in_room(room_id, client_id)
    end
  end

  context 'room is empty' do
    let(:response) do
      MultiJson.dump({ event: 'callerSuccess', payload: {} })
    end
    it_should_behave_like 'successful call message'

    it 'sends a callerSuccess response to the client' do
      add_listener

      send_message(message)

      assert_response(response)
    end
  end

  context 'room is not empty' do
    let(:other_client_id) { '4d3d3d3d' }
    let(:other_client_types) { client_types }
    let(:other_acceptable_peer_types) { acceptable_peer_types }
    let(:other_badge) { {} }
    let(:client_info) do
      { client_types: other_client_types,
        acceptable_peer_types: other_acceptable_peer_types,
        badge: other_badge }
    end

    before { add_to_room(room_id, other_client_id, client_info) }

    context 'client and peer types match' do
      let(:response) do
        MultiJson.dump({ event: 'calleeSuccess', payload: {} })
      end

      it_should_behave_like 'successful call message'

      xit 'sends a calleeSuccess response to the client' do
        add_listener

        send_message(message)

        assert_response(response)
      end
    end
  end
end
