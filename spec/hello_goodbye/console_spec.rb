describe HelloGoodbye::Console do

  let(:console) do
    h = HelloGoodbye::Console.new 1

    # Override EM method for this object
    def h.send_data(data)
      # Do nothing
    end

    def h.close_connection
      # Do nothing
    end

    h
  end

  describe ".get" do
    it "should raise error when console not recognized" do
      expect{
        HelloGoodbye::Console.get(:nothing)
      }.to raise_error
    end
    it "should return a manager console" do
      HelloGoodbye::Console.get(:manager).should be(HelloGoodbye::ManagerConsole)
    end
  end

  describe "#receive_command" do
    it "should return false on unknown actions" do
      console.receive_command("custom_action").should be(false)
    end
    
    it "should return true on known actions" do
      console.receive_command("hello").should be(true)
    end
  end

  context "basic commands" do
    it "should reply to hello" do
      command_to_console(console,"hello")["message"].should eq("hello")
    end
    it "should reply to goodbye and close connection" do
      command_to_console(console,"goodbye")["message"].should eq("goodbye")
      console.connection_closed?().should be_true
    end
  end
end
