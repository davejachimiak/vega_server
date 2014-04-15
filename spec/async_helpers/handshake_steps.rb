require 'async_helpers/setup_teardown_steps'

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

