describe HelloGoodbye::ManagerConsole do
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

  let(:manager_console) do
    m = HelloGoodbye::ManagerConsole.new(1)
    m.foreman = @manager
    m
  end

  context "when running with a manager" do
    it "should report on active foreman" do
      start_foremen_manager_and(manager) do |manager|
        h = command_to_console(manager_console, "foremen")
        h["results"].size.should be(1)
      end
    end

    it "should start foremen by name" do
      start_foremen_manager_and(manager) do |manager|
        h = command_to_console(manager_console, "start test")
        h["results"].first.should be(0)
        manager_console.foreman.foremen.first[:reference].running?().should be_true

        h = command_to_console(manager_console, "stop 0")
        h["results"].first.should be(0)
        manager_console.foreman.foremen.first[:reference].running?().should be_false
      end
    end

    it "should start all foremen with 'all'" do
      h = command_to_console(manager_console, "start all")
      h["results"].first.should be(0)
      manager_console.foreman.foremen.first[:reference].running?().should be_true
    end
  end

end
