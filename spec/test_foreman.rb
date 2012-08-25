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
