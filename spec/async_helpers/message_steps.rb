VegaServer::MessageSteps = RSpec::EM.async_steps do
  include VegaServer::SetupTeardownSteps

  def add_to_room(client_id, client_info, &callback)
    EM.next_tick do
      storage = VegaServer.storage
      storage.add_to_room(client_id, client_info)
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

  def add_listener(client, &callback)
    EM.next_tick do
      ws = instance_variable_get "@#{client}"

      ws.on :message do |event|
        messages = instance_variable_get "@#{client}_messages"

        messages ||= []
        messages.push event.data

        instance_variable_set "@#{client}_messages", messages
      end

      callback.call
    end
  end

  def send_message(client, message, &callback)
    EM.add_timer 0.1 do
      ws = instance_variable_get "@#{client}"
      ws.send(message)
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

  def refute_connection_in_pool(&callback)
    EM.add_timer 0.1 do
      ws = VegaServer.connection_pool[@client_id]
      expect(ws).to be_nil
      EM.next_tick(&callback)
    end
  end

  def assert_client_in_room(room_id, client_id, &callback)
    EM.add_timer 0.1 do
      storage = VegaServer.storage

      if room = storage.room(room_id)
        expect(room.include?(client_id)).to be_true
        expect(storage.client(client_id)).to_not be_nil
      else
        fail 'room does not exist'
      end

      EM.next_tick(&callback)
    end
  end

  def refute_client_in_room(room_id, client_id, &callback)
    EM.add_timer 0.1 do
      storage = VegaServer.storage

      if room = storage.room(room_id)
        expect(room.include?(client_id)).to be_false
        expect(storage.client(client_id)).to be_nil
      else
        pass
      end

      EM.next_tick(&callback)
    end
  end

  def assert_response(client, response, &callback)
    EM.add_timer 0.1 do
      messages = instance_variable_get "@#{client}_messages"
      expect(messages).to include response
      callback.call
    end
  end
end
