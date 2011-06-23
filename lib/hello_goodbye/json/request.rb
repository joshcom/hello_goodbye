module HelloGoodbye
  class Request
    attr_accessor :request_hash
    attr_reader :command

    def initialize(str)
      self.request_data=str
    end

    def request_data=(str)
      @request_hash = JSON.parse(str)
      unless @request_hash.include?("command")
        raise ArgumentError, 
          "The JSON string you supplied is invalid.  All requests must include a 'command' attribute."
      end
      @command = @request_hash["command"]
      @request_hash
    end
  end
end
