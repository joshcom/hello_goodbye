require File.expand_path('lib/hello_goodbye')

module HelloGoodbye
  class TestConsole < Console
    def receive_command(command)
      case command
      when "custom"
        send_response :success => true,
          :message => "test command"
        return true
      when "error"
        send_response :success => true,
          :message => "oops"
        raise RuntimeError, "Oh noooooes!"
      end
      super
    end
  end
end
