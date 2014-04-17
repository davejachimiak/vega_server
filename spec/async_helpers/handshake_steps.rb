require 'async_helpers/setup_teardown_steps'

VegaServer::HandshakeSteps = RSpec::EM.async_steps do
  include VegaServer::SetupTeardownSteps

  def assert_socket_open(client, &callback)
    EM.add_timer 0.1 do
      open = instance_variable_get "@#{client}_open"
      expect(open).to be_true
      EM.next_tick(&callback)
    end
  end

  def assert_socket_closed(client, &callback)
    EM.add_timer 0.1 do
      open = instance_variable_get "@#{client}_open"
      expect(open).to be_false
      EM.next_tick(&callback)
    end
  end
end

