require 'spec_helper'

describe 'call message is received' do
  include VegaServer::MessageSteps

  let(:client) { 'client' }
  let(:message) { MultiJson.dump(raw_message) }
  let(:raw_message) { { type: 'call', payload: payload } }
  let(:payload) { { roomId: room_id, badge: badge } }
  let(:room_id) { '/chat/abc123' }
  let(:badge) { {} }
  let(:client_id) { 'yup' }

  before do
    start_server
    open_socket(client)
    stub_client_id(client_id)
  end

  after { stop_server }

  shared_examples_for 'call message' do
    it 'adds the connection to the pool' do
      send_message(client, message)
      assert_connection_in_pool
    end
  end

  shared_examples_for 'successful call message' do
    it_should_behave_like 'call message'

    it 'adds the client to the room' do
      send_message(client, message)
      assert_client_in_room(room_id, client_id)
    end
  end

  context 'room is empty' do
    let(:response) do
      MultiJson.dump({ type: 'callerSuccess', payload: {} })
    end
    it_should_behave_like 'successful call message'

    it 'sends a callerSuccess response to the client' do
      add_listener(client)
      send_message(client, message)
      assert_response(client, response)
    end
  end

  context 'room is not empty' do
    let(:other_client_id) { '4d3d3d3d' }
    let(:other_badge) { {} }
    let(:client_info) { { badge: other_badge, room_id: room_id } }

    before { add_to_room(other_client_id, client_info) }

    context 'room is not full' do
      #TODO Protocol change: send all peerIds in room to callee

      let(:response) do
        MultiJson.dump({ type: 'calleeSuccess', payload: {} })
      end

      it_should_behave_like 'successful call message'

      it 'sends a calleeSuccess response to the client' do
        add_listener(client)
        send_message(client, message)
        assert_response(client, response)
      end
    end

    context 'room is full' do
      let(:response) do
        MultiJson.dump({ type: 'roomFullError', payload: {} })
      end

      before { set_max_capacity('/chat', 1) }
      after { reset_capacities }

      it_should_behave_like 'call message'

      it 'should not add the client to the room' do
        send_message(client, message)
        refute_client_in_room(room_id, client_id)
      end

      it 'sends a roomFullError response to the client' do
        add_listener(client)
        send_message(client, message)
        assert_response(client, response)
      end
    end
  end
end
