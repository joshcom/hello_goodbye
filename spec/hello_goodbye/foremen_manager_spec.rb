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
      manager.foremen.size.should be(1)
    end

    it "should not have any running foreman" do
      manager.foremen.each do |f|
        f[:running].should be_false
      end
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
          f[:running].should be_true
          f[:reference].should be_a(HelloGoodbye::TestForeman)
        end
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
  end
end
