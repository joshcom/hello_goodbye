describe HelloGoodbye::ForemenManager do
  context "when starting the manager" do
    it "should span a responsive console" do
      start_foremen_manager_and do |manager|
        EM.run do 
          expect { 
            c = TCPSocket.open(default_server,default_port) 
            c.close
          }.to_not raise_error
        end
      end
    end
  end
end
