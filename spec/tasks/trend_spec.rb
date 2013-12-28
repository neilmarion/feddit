require 'spec_helper'

describe "trend:hot" do
  include_context "rake"

  it "gets all the hot trends" do
    stub_request(:get, "http://www.reddit.com/hot.json").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => HOT_RESPONSE, :headers => {})
    expect {
      subject.invoke
    }.to change(Trend, :count).by 1
  end
end
