VegaServer::HandshakeSteps = RSpec::EM.async_steps do
  def configure_origins(origins, &callback)
    VegaServer.configure do |config|
      config.allow_origins(origins)
    end
    EM.next_tick(&callback)
  end

  def start_server &callback
    vega = VegaServer::Server.new
    events = Puma::Events.new(StringIO.new, StringIO.new)
    binder = Puma::Binder.new(events)
    binder.parse(["tcp://0.0.0.0:9292"], vega)
    @server = Puma::Server.new(vega, events)
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

    @ws = Faye::WebSocket::Client.new('ws://0.0.0.0:9292')

    @ws.instance_variable_set(:@headers, { 'HTTP_ORIGIN' => origin })

    @ws.on(:open) { |e| resume.call(true) }
    @ws.onclose = lambda { |e| resume.call(false) }
  end

  def assert_socket_open(&callback)
    expect(@open).to eq true
    EM.next_tick(&callback)
  end

  def assert_socket_closed(&callback)
    expect(@open).to eq false
    EM.next_tick(&callback)
  end
end
