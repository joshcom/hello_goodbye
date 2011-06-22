describe HelloGoodbye::Foreman do
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
end
