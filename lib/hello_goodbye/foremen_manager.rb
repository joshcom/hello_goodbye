module HelloGoodbye
  class ForemenManager
    require File.expand_path('lib/hello_goodbye/console')

    attr_accessor :server, :port

    DEFAULT_SERVER = "127.0.0.1"
    DEFAULT_MANAGER_PORT = 8080

    def initialize(options={})
      options.map do |key,value|
        self.send("#{key}=",value) if self.respond_to?("#{key}=".to_sym)
      end
    end

    def server 
      @server || DEFAULT_SERVER
    end

    def port
      @port || DEFAULT_MANAGER_PORT
    end

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

    # Starts the manager console and all the
    # registered foremen.
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
      EM::start_server(self.server, self.port, Console.get(:manager))
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
        self.foremen.each do |foreman|
          EM::start_server(self.server, foreman[:port], forman[:class])
        end
      end
    end
  end
end
