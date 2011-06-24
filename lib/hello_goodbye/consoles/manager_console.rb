module HelloGoodbye
  class ManagerConsole < Console
    def receive_command(command)
      case command
      when /^start/
        # TODO: Grab the ID, and start the foreman.
        return true
      when /^stop /
        # TODO: Grab the ID, and stop the foreman.
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
