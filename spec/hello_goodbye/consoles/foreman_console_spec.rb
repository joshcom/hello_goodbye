describe HelloGoodbye::Console do

  before(:all) do
    @foreman = HelloGoodbye::TestForeman.new
  end

  let(:foreman_console) do
    f = HelloGoodbye::TestConsole.new(1)
    f.foreman = @foreman
    f
  end

  let(:foreman) do
    @foreman
  end

  context "starting and stopping the foreman" do
    it "should start the foreman class from the console" do
      r = command_to_console(foreman_console,"start")
      r["message"].should eq("ok")
      foreman.status.should be(:started)
    end

    it "should stop the foreman class from the console" do
      r = command_to_console(foreman_console,"stop")
      r["message"].should eq("ok")
      foreman.status.should be(:stopped)
    end
  end
end
