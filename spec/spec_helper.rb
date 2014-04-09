require 'puma'
require './lib/vega_server'
require 'rspec/em'
require 'pry'

VegaSteps = RSpec::EM.async_steps do
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
    @server.stop
    EM.next_tick(&callback)
  end

  def open_socket(&callback)
    done = false

    resume = lambda do |open|
      unless done
        done = true
        @open = open
      end
    end

    @ws = Faye::WebSocket::Client.new('ws://0.0.0.0:9292')

    @ws.on(:open) { |e| resume.call(true) }
    @ws.onclose = lambda { |e| resume.call(false) }
    callback.call
  end

  def assert_socket_open(&callback)
    binding.pry
    expect(@open).to eq true
    EM.next_tick(&callback)
  end
end

