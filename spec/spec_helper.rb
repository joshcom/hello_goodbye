require File.expand_path('../../lib/hello_goodbye',__FILE__)
require 'rspec'

# Possibly the most important helper method.
# This method, in the following order:
# 1. Starts an event loop
# 2. Executes #start! on either the parameter ForemenManager or
#    creates a new ForemenManager and executes start! on that.
# 3. Yields to a given block, passing the ForemenManager to that block.
# 4. Stops the event loop.
def start_foremen_manager_and(f=spec_manager)
  EM.run_block do
    f.start!
    yield(f)
  end
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
