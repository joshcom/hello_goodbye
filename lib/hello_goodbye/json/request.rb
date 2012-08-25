module HelloGoodbye
  class Request
    attr_accessor :request_hash
    attr_reader :command

    def initialize(str)
      self.request_data=str
    end

    def request_data=(str)
      @request_data = JSON.parse(str)
      unless @request_data.include?("command")
        raise ArgumentError, 
          "The JSON string you supplied is invalid.  All requests must include a 'command' attribute."
      end
      @command = @request_data["command"]
      @request_data
    end
  end
end
