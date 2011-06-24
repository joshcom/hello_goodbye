module HelloGoodbye

  # Commands shared by all consoles:
  # * 'hello'   => Used to ping the server.  
  #                Responds with 'hello'.
  # * 'goodbye' => Used to close a connection.  
  #                Responds with 'goodbye'.
  class Console < EventMachine::Connection

    require File.expand_path('lib/hello_goodbye/consoles/foreman_console')
    require File.expand_path('lib/hello_goodbye/consoles/manager_console')
    require File.expand_path('lib/hello_goodbye/json/request')
    require File.expand_path('lib/hello_goodbye/json/response')

    # :foreman
    #   A reference to the Foreman object that instantiated the console, so that
    #   the console can serve as an interface to this object.
    attr_accessor :foreman

    # Returns a standard console of a given type.  I'm aware this logic is dumb.
    # Parameters:
    # * type
    # ** :manager => ManagerConsole
    def self.get(type)
      case type
      when :manager
        ManagerConsole
      when :foreman
        ForemanConsole
      else
        if (obj = HelloGoodbye.const_get("#{type}_console".split('_').collect(&:capitalize).join))
            obj
        else
          raise ArgumentError, "What type of console is #{type}?"
        end
      end
    end

    # Returns:
    #   true if data was handled, false if not.
    def receive_command(command)
      case command 
      when "hello"
        send_response :success => true,
          :message => "hello"
        return true
      when "goodbye"
        send_response :success => true,
          :message => "goodbye"
        close_connection
        return true
      else
        send_response :success => false,
          :message => "unknown command"
      end
      false
    end

    # Parameters:
    #   hash
    #   * success => true or false
    #   * message => "Your message"
    #   * results => []
    def send_response(hash)
      send_data Response.new(hash).to_json
    end

    def receive_data(data)
      receive_command(Request.new(data))
    end
  end
end
