require 'spec_helper'

describe "trend:hot" do
  include_context "rake"
  let(:user) { FactoryGirl.create(:user) }
  let(:mail_trend) { UserMailer.daily_trend_email(user) }

  it "gets all the hot trends and sends emails" do
    stub_request(:get, "http://www.reddit.com/hot.json").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => HOT_RESPONSE, :headers => {})
    expect {
      subject.invoke
    }.to change(Topic, :count).by 25

    mail_trend.subject.should eq("Top Stories of the Day")
    mail_trend.to.should eq([user._id])
    mail_trend.from.should eq(["newsletter@fedd.it"])
  end
end
