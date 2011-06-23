module HelloGoodbye
  class Response
    attr_accessor :success, :results, :message

    def initialize(options={})
      options.map do |key,value|
        self.send("#{key}=".to_sym,value) if self.respond_to?("#{key}=".to_sym)
      end
    end

    def success
      (@success == true ? true : false )
    end

    def results=(r)
      if r.nil?
        @results = nil
      else
        @results = Array(r)
      end
    end 

    def to_hash
      h = {
        "success" => self.success,
        "message" => self.message.to_s
      }
      h["results"] = self.results if !self.results.nil?
      h
    end

    def to_json
      self.to_hash.to_json
    end
  end
end
