require File.expand_path('lib/hello_goodbye')

module HelloGoodbye
  class TestForeman < Foreman
    set_console_type :test
  end
end
