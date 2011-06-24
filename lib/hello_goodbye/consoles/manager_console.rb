module HelloGoodbye
  class ManagerConsole < Console
    def receive_command(command)
      case command
      when /^start/
        # TODO: Grab the ID, and start the foreman.
        send_response :success => true,
          :message => "start will be implemented soon"
        return true
      when /^stop /
        # TODO: Grab the ID, and stop the foreman.
        send_response :success => true,
          :message => "stop will be implemented soon"
        return true
      when "foremen"
        send_response :success => true, :message => "ok", 
          :results => self.foreman.report
        return true
      end
      super
    end
  end
end
