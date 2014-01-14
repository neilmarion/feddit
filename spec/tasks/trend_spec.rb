require 'spec_helper'

describe "trend:hot" do
  include_context "rake"

  it "gets all the hot trends" do
    stub_request(:get, "http://www.reddit.com/hot.json").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => HOT_RESPONSE, :headers => {})

    stub_request(:get, "http://www.reddit.com/r/pics.json").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => PICS_RESPONSE, :headers => {})

    expect {
      subject.invoke
    }.to change(Topic, :count).by 50 

    Topic.where(subreddit: "pics").count.should eq 25
    Topic.where(is_hot: true).count.should eq 25
  end
end

describe "trend:newsletter" do
  include_context "rake"
  let(:user) { FactoryGirl.create(:user_activated) }
  let(:mail_trend) { UserMailer.daily_trend_email(user, Topic.topics_today("hot"), user.subreddits.first) }

  before :each do
    FactoryGirl.create(:topic)
  end

  it "sends the newsfeed emails" do
    FactoryGirl.create(:topic, subreddit: "hot", is_hot: true)
    FactoryGirl.create(:topic, subreddit: "pics")
    newsletter_hot = FactoryGirl.create(:newsletter, _id: "hot")
    newsletter_pics = FactoryGirl.create(:newsletter, _id: "pics")

    Newsletter.find_by(_id: "hot").topics.should eq [] 
    Newsletter.find_by(_id: "pics").topics.should eq [] 


    SUBREDDITS.each do |subreddit|
      MailingList.find_or_create_by(_id: subreddit, emails: ["user1@email.com"])
    end

    expect {
      subject.invoke
    }.to_not change(Newsletter, :count)

    Newsletter.find_by(_id: "pics").topics.should_not eq [] 
    Newsletter.find_by(_id: "hot").topics.should_not eq [] 

    mail_trend.subject.should eq("Top Reddits of the Day /r/hot - #{Time.now.strftime("%B %e, %Y")}")
    mail_trend.to.should eq([user._id])
    mail_trend.from.should eq(["newsletter@fedd.it"])
  end
end
