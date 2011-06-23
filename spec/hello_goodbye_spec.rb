describe HelloGoodbye do
  describe "Mother Module" do
    it  "should create a new manager" do
      m = HelloGoodbye.manager
      m.should be_a(HelloGoodbye::ForemenManager)
    end

    it "should return the same manager instance" do
      m = HelloGoodbye.manager(2000,"joshcom.net")
      m2 = HelloGoodbye.manager
      m.should be(m2)
    end

    it "should create a new manager instance after reset!" do
      m = HelloGoodbye.manager(2000,"joshcom.net")
      HelloGoodbye.reset!
      m2 = HelloGoodbye.manager
      m.should_not be(m2)
    end
  end
end
