module HelloGoodbye
  require 'hello_goodbye/console'
  require 'hello_goodbye/foreman'
  class ForemenManager < Foreman

    DEFAULT_MANAGER_PORT = 8080

    set_console_type :manager

    def self.default_manager_port
      DEFAULT_MANAGER_PORT
    end

    def initialize(options={})
      @next_foreman_id = -1
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

    def next_foreman_id
      @next_foreman_id += 1
    end

    # Registers a new forman
    # Parameters:
    # * foreman_hash
    #     :port => (int) Port number to listen on.
    #     :class => A reference to the foreman class
    #               that will handle the connection and spawn
    #               workers.
    def register_foreman(foreman_hash)
      self.foremen << foreman_hash.merge(:reference => nil, :id => next_foreman_id)
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

    # Start the consoles for all foremen.  This does not start
    # employing workers.
    def start_foremen
      self.foremen.each do |foreman|
        foreman[:reference] = foreman[:class].new(:server => self.server, 
                                                  :port => foreman[:port])
        foreman[:reference].start!
      end
    end

    # Trigger all formen to either start or stop employing workers.
    # Parameters:
    # * mode => :start or :stop
    # * id =>  The foreman's integer ID or name
    def trigger_foreman(mode,id)
      [].tap do |toggled_foremen|
        self.foremen.each do |foreman|
          if foreman[:reference].nil? || (id != "all" && foreman[:reference].my_name != id && foreman[:id] != id.to_i)
            next
          end
          next if mode == :start && foreman[:reference].running?
          next if mode == :stop && !foreman[:reference].running?

          if mode == :start
            foreman[:reference].employ
          else
            foreman[:reference].unemploy
          end
          toggled_foremen << foreman[:id]
        end
      end
    end

    def report
      [].tap do |r|
        self.foremen.each do |foreman|
          r << {
            :id =>  foreman[:id],
            :name => foreman[:reference].my_name,
            :status => foreman[:reference].status.to_s
          }
        end
      end
    end
  end
end
