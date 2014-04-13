VegaServer::SetupTeardownSteps = RSpec::EM.async_steps do
  def enable_modified_event(&callback)
    EM.next_tick { VegaServer.enable_modified_event! }
    EM.next_tick(&callback)
  end

  def disable_modified_event(&callback)
    EM.next_tick { VegaServer.disable_modified_event! }
    EM.next_tick(&callback)
  end

  def configure_origins(origins, &callback)
    VegaServer.configure { |config| config.allow_origins(origins) }
    EM.next_tick(&callback)
  end

  def start_server &callback
    @vega = VegaServer::Server.new
    events = Puma::Events.new(StringIO.new, StringIO.new)
    binder = Puma::Binder.new(events)
    binder.parse(["tcp://0.0.0.0:9292"], @vega)
    @server = Puma::Server.new(@vega, events)
    @server.binder = binder
    @server.run
    EM.add_timer(0.1, &callback)
  end

  def stop_server(&callback)
    @server.stop(true)
    EM.next_tick(&callback)
  end

  def open_socket(origin=nil, &callback)
    done = false

    resume = lambda do |open|
      unless done
        done = true
        @open = open
        callback.call
      end
    end

    VegaServer.event_adapter.origin = origin if origin

    @ws = Faye::WebSocket::Client.new('ws://0.0.0.0:9292')

    @ws.on(:open) { |e| resume.call(true) }
    @ws.onclose = lambda do |e|
      @open = false
      @ws = nil
    end
  end

  def reset_allowed_origins(&callback)
    EM.next_tick { VegaServer.allow_origins([]) }
    EM.next_tick(&callback)
  end
end

VegaServer::HandshakeSteps = RSpec::EM.async_steps do
  include VegaServer::SetupTeardownSteps

  def assert_socket_open(&callback)
    EM.add_timer 0.1 do
      expect(@open).to be_true
      EM.next_tick(&callback)
    end
  end

  def assert_socket_closed(&callback)
    EM.add_timer 0.1 do
      expect(@open).to be_false
      EM.next_tick(&callback)
    end
  end
end

VegaServer::CallMessageSteps = RSpec::EM.async_steps do
  include VegaServer::SetupTeardownSteps

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

  def assert_response(response, &callback)
    EM.add_timer 0.1 do
      expect(@messages_from_server).to include response
      callback.call
    end
  end
end
