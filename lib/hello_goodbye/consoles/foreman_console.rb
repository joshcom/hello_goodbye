module HelloGoodbye
  class ForemanConsole < Console
    def receive_command(command)
      case command
      when "start"
        self.foreman.employ
        send_response :success => true,
          :message => "ok"
        return true
      when "stop"
        self.foreman.unemploy
        send_response :success => true,
          :message => "ok"
        return true
      when "status"
        send_response :success => true,
          :message => self.foreman.status.to_s
        return true
      end
      super
    end
  end
end
