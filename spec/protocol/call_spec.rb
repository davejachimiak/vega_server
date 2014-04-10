require 'spec_helper'
require 'multi_json'

describe 'call message is received' do
  include VegaServer::CallMessageSteps

  context 'room is empty' do
    let(:message) { MultiJson.dump(raw_message) }
    let(:raw_message) { { event: 'call', payload: payload } }
    let(:payload) do
      { roomId: room_id,
        clientTypes: client_types,
        acceptablePeerTypes: acceptable_peer_types,
        badge: badge }
    end
    let(:room_id) { 'abc123' }
    let(:client_types) { ['any'] }
    let(:acceptable_peer_types) { ['any'] }
    let(:badge) { {} }
    let(:client_id) { 'yup' }

    it 'adds the connection to the pool' do
      start_server
      open_socket
      stub_client_id(client_id)

      send_message(message)

      assert_connection_in_pool
    end
  end
end
