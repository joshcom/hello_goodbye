describe HelloGoodbye::Request do
  let(:request) do
    HelloGoodbye::Request
  end
  describe "#request_data" do
    it "should require valid json" do
      expect {
        request.new("So not JSON")
      }.to raise_error
    end
    
    it "should require a command attribute" do
      expect {
        request.new '{"success": true}'
      }.to raise_error
    end

    it "should be successful with a command" do
      expect {
        request.new '{"command": "hello"}'
      }.to_not raise_error
    end

    it "should set command attribute" do
      request.new('{"command": "hello"}').command.should eq("hello")
    end
  end
end
