VegaServer::HandshakeSteps = RSpec::EM.async_steps do
  def enable_modified_env(&callback)
    EM.next_tick { VegaServer.enable_modified_env! }
    EM.next_tick(&callback)
  end

  def disable_modified_env(&callback)
    EM.next_tick { VegaServer.disable_modified_env! }
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

  def open_socket(origin, &callback)
    done = false

    resume = lambda do |open|
      unless done
        done = true
        @open = open
        callback.call
      end
    end

    VegaServer.env_adapter.origin = origin

    @ws = Faye::WebSocket::Client.new('ws://0.0.0.0:9292')

    @ws.on(:open) { |e| resume.call(true) }
    @ws.onclose = lambda do |e|
      @open = false
      @ws = nil
    end
  end

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

  def reset_allowed_origins(&callback)
    EM.next_tick { VegaServer.allow_origins([]) }
    EM.next_tick(&callback)
  end
end
