require 'hello_goodbye'
require 'spec/test_foreman'
require 'spec/test_console'
require 'hello_goodbye/json/request'
require 'hello_goodbye/json/response'

require 'rspec'

# Possibly the most important helper method.
# This method, in the following order:
# 1. Starts an event loop
# 2. Executes #start! on either the parameter ForemenManager or
#    creates a new ForemenManager and executes start! on that.
# 3. Yields to a given block, passing the ForemenManager to that block.
# 4. Stops the event loop.
def start_foremen_manager_and(f=spec_manager)
  f.instance_variable_set("@foreman_started",false)
  EM.run_block do
    f.start!
    yield(f)
  end
end

def command_to_json_str(command)
  {
    :command => command
  }.to_json
end

def command_to_console(console,command)
  sent_data = nil
  override_method(console,'send_data') do |data|
    sent_data = data
  end
  override_method(console,'close_connection') do
    @test_connection_closed = true
  end
  override_method(console,'connection_closed?') do
    @test_connection_closed || false
  end
  console.receive_command(command)
  build_response_hash(sent_data)
end

def override_method(console,method,&block)
  (class << console; self; end).send(:define_method, method) do |*args|
      block.call(*args)
  end
end

def build_response_hash(data)
  JSON.parse(data)
end

def default_server
  "127.0.0.1"
end

def default_port
  8080
end

def spec_manager
  HelloGoodbye::ForemenManager.new(:port => default_port,
                                   :server => default_server)
end
