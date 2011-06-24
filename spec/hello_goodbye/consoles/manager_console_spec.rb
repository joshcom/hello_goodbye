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
  end

end
