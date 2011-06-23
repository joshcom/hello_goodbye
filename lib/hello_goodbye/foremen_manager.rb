module HelloGoodbye
  require File.expand_path('lib/hello_goodbye/console')
  require File.expand_path('lib/hello_goodbye/foreman')
  class ForemenManager < Foreman

    DEFAULT_MANAGER_PORT = 8080

    set_console_type :manager

    def self.default_manager_port
      DEFAULT_MANAGER_PORT
    end

    def initialize(options={})
      options.map do |key,value|
        self.send("#{key}=",value) if self.respond_to?("#{key}=".to_sym)
      end
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
      self.foremen << foreman_hash.merge(:running => false, :reference => nil)
    end

    # Starts the manager console and all the
    # registered foremen.
    def start!
      super do
        self.start_foremen
      end
    end
    
    def on_error(&block)
      EM::error_handler do |e|
        block.call
      end
    end

    def start_foremen
      # Umm..this hash kind of blows.
      self.foremen.each do |foreman|
        foreman[:reference] = foreman[:class].new(:server => self.server, 
                                                  :port => foreman[:port])
        foreman[:reference].start!
        foreman[:running] = true
      end
    end
  end
end
