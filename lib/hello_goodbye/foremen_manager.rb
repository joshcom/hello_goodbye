module HelloGoodbye
  class ForemenManager
    require File.expand_path('lib/hello_goodbye/console')

    def foremen
      @foremen ||= []
    end

    # Registers a new forman
    # Parameters:
    # * foreman_hash
    #     :port => (int) Port number to listen on.
    #     :class => A reference to the foreman class
    #               that will handle the connection and spawn
    #               workers.
    def register_foreman(foreman_hash)
      self.foremen << foreman
    end

    def start!
      start_with_reactor do
        self.start_console
        self.start_foremen
      end
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

    def start_console
      # TODO: Again, don't hardcode address, and certainly not the
      # port
      EM::start_server("127.0.0.1", 8080, Console.get(:manager))
    end

    def start_foremen
      # TODO: Allow custom error handler to be attached to class.
      # Delete this block.
      EM::error_handler do |e|
        puts "Whoops, you had an error: #{e.message}"
        puts e.backtrace
      end

      # TODO: We will want run to be executed here, but ONLY if
      # we're not already in an event loop.
      EM::run do
        # TODO: I guess I don't know why the hell we'd ever run this on anything but
        # 127.0.0.1, but either way, let's make it optional
        self.foremen.each do |foreman|
          EM::start_server("127.0.0.1", foreman[:port], forman[:class])
        end
      end
    end
  end
end
