describe HelloGoodbye::ForemenManager do

  before(:all) do
    @manager = HelloGoodbye::ForemenManager.new
  end

  let(:manager) do
    @manager
  end

  describe ".console_type" do
    it "should be :manager" do
      HelloGoodbye::ForemenManager.console_type.should be(:manager)
    end
  end

  context "when registering foremen" do
    it "should allow foremen to be registered" do
      manager.register_foreman({
        :port => 8081,
        :class => HelloGoodbye::TestForeman
      })
      manager.register_foreman({
        :port => 8082,
        :class => HelloGoodbye::TestForeman,
        :options => {:test_option => "set!"}
      })
      manager.foremen.size.should be(2)
    end

    it "should give each forman unique ids" do
      manager.foremen.first[:id].should_not eq(manager.foremen[1][:id])
    end
    it "should not have references to objects" do
      manager.foremen.each do |f|
        f[:reference].should be_nil
      end
    end
  end

  context "when starting the manager" do
    it "should spawn a responsive console" do
      start_foremen_manager_and do |manager|
        EM.run_block do 
          expect { 
            c = TCPSocket.open(default_server,default_port) 
            c.close
          }.to_not raise_error
        end
      end
    end

    it "should start foremen" do
      start_foremen_manager_and(manager) do |manager|
        manager.foremen.each do |f|
          f[:reference].should be_a(HelloGoodbye::TestForeman)
        end
      end
    end

    it "should pass options to registered foremen" do
      start_foremen_manager_and(manager) do |manager|
        manager.foremen.first[:reference].test_option.should be_nil
        manager.foremen[1][:reference].test_option.should eq('set!')
      end
    end

    it "should spawn a responsive console for foremen" do
      start_foremen_manager_and(manager) do |manager|
        EM.run_block do 
          expect { 
            c = TCPSocket.open(default_server,manager.foremen.first[:reference].port) 
            c.close
          }.to_not raise_error
        end
      end
    end

    it "should report active foreman" do
      start_foremen_manager_and(manager) do |manager|
        EM.run_block do 
          manager.report.first.should eq({:id => manager.foremen.first[:id], 
                                          :name => "test", :status => "stopped"})
          manager.foremen.first[:reference].employ
          manager.report.first.should eq({:id => manager.foremen.first[:id],
                                         :name => "test", :status => "running"})
        end
      end

    end
  end
end
