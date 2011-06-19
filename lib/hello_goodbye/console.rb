module HelloGoodbye
  # Commands shared by all consoles:
  # * 'hello'   => Used to ping the server.  
  #                Responds with 'hello'.
  # * 'goodbye' => Used to close a connection.  
  #                Responds with 'goodbye'.
  class Console < EventMachine::Connection

    require File.expand_path('lib/hello_goodbye/consoles/manager_console')

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
      end
    end

    # Returns:
    #   true if data was handled
    def receive_data(data)
      case data
      when /^hello\s*$/
        send_data "hello\n"
        return true
      when /^goodbye\s*$/
        send_data "goodbye\n"
        close_connection
        return true
      end
      false
    end
  end
end
