module HelloGoodbye
  class Foreman

    attr_accessor :server, :port, :console

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

    def initialize(options={})
      self.server = options[:server]
      self.port = options[:port]
    end

    def start
      raise ArgumentError, "Foreman.start must be implemented by child class."
    end

    def stop
      raise ArgumentError, "Foreman.start must be implemented by child class."
    end

    # Reports the current status of the foreman.
    # Returns:
    #  * :stopped if the foreman is not currently employing workers.
    #  * :started if the foreman is active
    def status
      @status || :stopped
    end

    # Sets the foreman status to either :started or :stopped
    def status=(status)
      @status = status.to_sym
    end

    # Sets the foreman status to :started and calls self.start
    def employ
      self.start
      self.status = :started
    end

    # Sets the foreman status to :stopped and calls self.stop
    def unemploy
      self.stop
      self.status = :stopped
    end

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
      me = self
      EM::start_server(self.server, self.port, Console.get(Foreman.console_type)) do |c|
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
