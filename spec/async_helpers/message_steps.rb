VegaServer::MessageSteps = RSpec::EM.async_steps do
  include VegaServer::SetupTeardownSteps

  def open_peer_socket(peer, &callback)
    done = false

    resume = lambda do |open|
      unless done
        done = true
        callback.call
      end
    end

    peer = instance_variable_set "@#{peer}", Faye::WebSocket::Client.new('ws://0.0.0.0:9292')

    peer.on(:open) { |e| resume.call(true) }
    peer.onclose = lambda do |e|
      peer = nil
    end
  end

  def send_peer_message(peer, message, &callback)
    EM.add_timer 0.1 do
      ws = instance_variable_get "@#{peer}"
      ws.send(message)
      EM.next_tick(&callback)
    end
  end

  def add_to_room(room_id, client_id, client_info, &callback)
    EM.next_tick do
      storage = VegaServer.storage
      storage.add_to_room(room_id, client_id, client_info)
    end

    EM.next_tick(&callback)
  end

  def stub_client_id(client_id, &callback)
    @client_id = client_id

    EM.next_tick do
      SecureRandom.stubs(:uuid).returns client_id
      EM.next_tick(&callback)
    end
  end

  def add_peer_listener(peer, &callback)
    EM.next_tick do
      ws       = instance_variable_get "@#{peer}"
      messages = instance_variable_set "@#{peer}_messages_from_server", []

      ws.on :message do |event|
        messages.push event.data
      end

      callback.call
    end
  end

  def add_listener(&callback)
    EM.next_tick do
      @ws.on :message do |event|
        @messages_from_server ||= []
        @messages_from_server.push event.data
      end

      callback.call
    end
  end

  def send_message(message, &callback)
    EM.add_timer 0.1 do
      @ws.send(message)
      EM.next_tick(&callback)
    end
  end

  def set_max_capacity(room_path, capacity, &callback)
    EM.next_tick do
      VegaServer.configure do |config|
        config.set_room_capacities({ room_path => capacity })
      end

      callback.call
    end
  end

  def reset_capacities(&callback)
    EM.next_tick { VegaServer.set_room_capacities({}) }
    EM.next_tick(&callback)
  end

  def assert_connection_in_pool(&callback)
    EM.add_timer 0.1 do
      ws = VegaServer.connection_pool[@client_id]
      expect(ws).to_not be_nil
      EM.next_tick(&callback)
    end
  end

  def assert_client_in_room(room_id, client_id, &callback)
    EM.add_timer 0.1 do
      storage = VegaServer.storage

      if room = storage[room_id]
        expect(room[client_id]).to_not be_nil
      else
        fail 'room does not exist'
      end

      EM.next_tick(&callback)
    end
  end

  def refute_client_in_room(room_id, client_id, &callback)
    EM.add_timer 0.1 do
      storage = VegaServer.storage

      if room = storage[room_id]
        expect(room[client_id]).to be_nil
      else
        pass
      end

      EM.next_tick(&callback)
    end
  end

  def assert_response(response, &callback)
    EM.add_timer 0.1 do
      expect(@messages_from_server).to include response
      callback.call
    end
  end

  def assert_peer_response(peer, response, &callback)
    EM.add_timer 0.1 do
      messages = instance_variable_get "@#{peer}_messages_from_server"
      expect(messages).to include response
      callback.call
    end
  end
end
