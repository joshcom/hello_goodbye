require File.expand_path('lib/hello_goodbye')

module HelloGoodbye
  class TestConsole < Console
    def receive_data(data)
      return true if super
      false
    end
  end
end
