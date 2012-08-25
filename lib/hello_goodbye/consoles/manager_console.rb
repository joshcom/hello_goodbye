module HelloGoodbye
  class ManagerConsole < Console
    def receive_command(command)
      case command
      when /^start /
        id = command.gsub(/^start /, "")
        if (started_foremen = self.foreman.trigger_foreman(:start, id))
          send_response :success => true,
            :message => "ok", 
            :results => started_foremen
        else
          send_response :success => false,
            :message => "no match for foreman '#{id}'"
        end
        return true
      when /^stop /
        id = command.gsub(/^stop /, "")
        if (stopped_foremen = self.foreman.trigger_foreman(:stop,id))
          send_response :success => true,
            :message => "ok", 
            :results => stopped_foremen
        else
          send_response :success => false,
            :message => "no match for foreman '#{id}'"
        end
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
