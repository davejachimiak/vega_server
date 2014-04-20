require 'spec_helper'

describe 'bad message' do
  include VegaServer::MessageSteps
  let(:client) { 'client' }

  shared_examples_for 'ignorable message' do
    it "ignores the message and doesn't blow up the server" do
      start_server
      open_socket(client)
      send_message(client, bad_message)
      stop_server
    end
  end

  context 'bad type' do
    let(:bad_message) do
      MultiJson.dump({ type: 'horse', payload: {} })
    end

    it_should_behave_like 'ignorable message'
  end

  context 'json message is not an object' do
    let(:bad_message) { MultiJson.dump('bad message') }

    it_should_behave_like 'ignorable message'
  end

  context 'message is not json' do
    let(:bad_message) { 'bad message' }

    it_should_behave_like 'ignorable message'
  end
end
