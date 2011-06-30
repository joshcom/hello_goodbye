require File.expand_path('../../lib/hello_goodbye',__FILE__)

module HelloGoodbye
  class TestForeman < Foreman
    set_console_type :test
    attr_accessor :test_option

    def initialize(options={})
      self.test_option = options[:test_option]
      super
    end
    
    def start
      # Do nothing
    end

    def stop
      # Do nothing
    end
  end
end
