module HelloGoodbye
  class ForemanConsole < Console
    def receive_data(data)
      return true if super
      false
    end
  end
end