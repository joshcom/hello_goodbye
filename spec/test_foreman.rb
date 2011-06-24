require File.expand_path('../../lib/hello_goodbye',__FILE__)

module HelloGoodbye
  class TestForeman < Foreman
    set_console_type :test
    
    def start
      # Do nothing
    end

    def stop
      # Do nothing
    end
  end
end
