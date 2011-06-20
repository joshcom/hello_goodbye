module HelloGoodbye
  class Foreman
    attr_accessor :server, :port

    DEFAULT_SERVER = "127.0.0.1"

    # Starts the console for the foreman.  Subclasses should implement this method,
    # passing a block to super to start up any tasks (AMQB subscriber, etc)
    # that may need to be done.
    def start!
      start_with_reactor do
        self.start_console
        yield if block_given?
      end
    end

    def server 
      @server || DEFAULT_SERVER
    end

    # TODO: Detect console type to get.
    def start_console
      EM::start_server(self.server, self.port, Console.get(:manager))
    end

    def start_with_reactor(&block)
      if EM.reactor_running?
        block.call
      else
        EM.run {
          block.call
        }
      end
    end
  end
end
