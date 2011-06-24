describe HelloGoodbye::Foreman do
  before(:all) do
    @manager = HelloGoodbye::ForemenManager.new
    @manager.register_foreman({
        :port => 8081,
        :class => HelloGoodbye::TestForeman
    })
  end
  let(:manager) do
    @manager
  end

  let(:foreman) do
    HelloGoodbye::Foreman
  end

  let(:test_foreman) do
    HelloGoodbye::TestForeman
  end

  describe ".console_type" do
    it "should default to type :foreman" do
      foreman.console_type.should be(:foreman)
    end

    it "should be overridable by custom consoles :test_foreman" do
      test_foreman.console_type.should be(:test)
    end
  end

  context "under the control of a manager" do
    it "should be stopped initially" do
      start_foremen_manager_and(manager) do |manager|
        manager.foremen.first[:reference].status.should be(:stopped)
      end
    end
    it "should be employable" do
      start_foremen_manager_and(manager) do |manager|
        f = manager.foremen.first[:reference]
        f.employ
        f.status.should be(:started)
      end
    end
    it "should be unemployable" do
      start_foremen_manager_and(manager) do |manager|
        f = manager.foremen.first[:reference]
        f.unemploy
        f.status.should be(:stopped)
      end
    end
  end
end
