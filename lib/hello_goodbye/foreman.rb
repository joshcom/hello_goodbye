module HelloGoodbye
  class Foreman

    attr_accessor :server, :port, :console, :my_id, :server_id
    attr_reader :foreman_started

    DEFAULT_SERVER = "127.0.0.1"

    # Overrides the default ForemanConsole console type
    # to fire up when #start! is called.
    def self.set_console_type(console_sym)
      @console_type = console_sym
    end

    # Returns the current console type for this class.
    def self.console_type
      @console_type ||= :foreman
    end

    def self.default_server
      DEFAULT_SERVER
    end

    # Parameters:
    # options:
    #  * server => 
    #  * port   => The port to run the server on
    def initialize(options={})
      self.server = options[:server]
      self.port = options[:port]
      @foreman_started = false
    end

    # Starts the foreman's worker spawning action.
    def start
      raise ArgumentError, "Foreman.start must be implemented by child class."
    end

    # Stops the foreman's worker spawning action.
    def stop
      raise ArgumentError, "Foreman.start must be implemented by child class."
    end

    # Starts the console for the foreman.  Subclasses should implement this method,
    # passing a block to super to start up any tasks (AMQB subscriber, etc)
    # that may need to be done.
    def start!
      raise RuntimeError, "Foreman already started!" if @foreman_started == true
      start_with_reactor do
        self.start_console
        yield if block_given?
      end
      @foreman_started = true
    end

    # Detects the name to report this foreman class as.
    # For example, will be "test" for "HelloGoodbye::TestForeman".
    def my_name
      begin
        self.class.name.match(/^HelloGoodbye::(.*)Foreman$/)[1].downcase
      rescue
        self.class.name
      end
    end

    # Reports the current status of the foreman.
    # Returns:
    #  * :stopped if the foreman is not currently employing workers.
    #  * :running if the foreman is active
    def status
      @status || :stopped
    end

    # true if the foreman is currently employing workers
    def running?
      self.status == :running
    end

    # Sets the foreman status to either :running or :stopped
    def status=(status)
      @status = status.to_sym
    end

    # Sets the foreman status to :running and calls self.start
    def employ
      self.start
      self.status = :running
    end

    # Sets the foreman status to :stopped and calls self.stop
    def unemploy
      self.stop
      self.status = :stopped
    end

    def server 
      @server || DEFAULT_SERVER
    end

    def start_console
      me = self
      self.server_id = EM::start_server(self.server, self.port, Console.get(self.class.console_type)) do |c|
        c.foreman = me 
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
  end
end
