describe HelloGoodbye::Response do
  let(:results_response) do
    HelloGoodbye::Response.new :success => true,
      :message => "Hi Mom!", :results => [{"color" => "blue"}]
  end
  let(:response) do
    HelloGoodbye::Response.new
  end

  it "should set fields from initialization" do
    results_response.success.should be_true
    results_response.message.should eq("Hi Mom!")
    results_response.results.first.should eq({"color" => "blue"})
  end

  it "should default to unsuccessful" do
    response.success.should be_false
  end

  it "should exclude results from hash when there are none" do
    response.to_hash["results"].should be_nil
  end

  it "should build a hash based on values" do
    results_response.to_hash["message"].should eq("Hi Mom!")
  end

  it "should build a hash based on values" do
    results_response.to_hash["results"].size.should eq(1)
  end

  it "should return a json string" do
    response.to_json.should be_a(String)
  end
end
