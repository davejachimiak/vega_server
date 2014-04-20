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
      MultiJson.dump({ type: 'callAccepted',
                       payload: { peerIds: [] } })
    end

    it_should_behave_like 'successful call message'

    it 'sends a `callAccepted` response with no peerIds' do
      add_listener(client)
      send_message(client, message)
      assert_response(client, response)
    end
  end

  context 'room is not empty' do
    let(:client_id1) { '4d3d3d3d' }
    let(:client_id2) { 'tayne' }
    let(:other_badge) { {} }
    let(:client_info) { { badge: other_badge, room_id: room_id } }

    before do
      add_to_room(client_id1, client_info)
      add_to_room(client_id2, client_info)
    end

    context 'room is not full' do
      let(:response) do
        MultiJson.dump({ type: 'callAccepted',
                         payload: { peerIds: [client_id1, client_id2] } })
      end

      it_should_behave_like 'successful call message'

      it 'sends a callAccepted response with the peer ids' do
        add_listener(client)
        send_message(client, message)
        assert_response(client, response)
      end
    end

    context 'room is full' do
      let(:response) do
        MultiJson.dump({ type: 'roomFull', payload: {} })
      end

      before { set_max_capacity('/chat', 2) }
      after { reset_capacities }

      it_should_behave_like 'call message'

      it 'should not add the client to the room' do
        send_message(client, message)
        refute_client_in_room(room_id, client_id)
      end

      it 'sends a roomFull response to the client' do
        add_listener(client)
        send_message(client, message)
        assert_response(client, response)
      end
    end
  end
end
