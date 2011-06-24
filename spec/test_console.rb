require File.expand_path('lib/hello_goodbye')

module HelloGoodbye
  class TestConsole < Console
    def command_data(command)
      super
    end
  end
end
