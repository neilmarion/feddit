require 'spec_helper'

describe Topic do
  before :each do
    @a = [FactoryGirl.create(:topic, ups: 8, is_hot: true, subreddit: 'programming'),
      FactoryGirl.create(:topic, ups: 10, is_hot: true, subreddit: 'pics'),
      FactoryGirl.create(:topic, ups: 9, subreddit: 'pics')]
  end

  it "gets all the hot topics for the day in descending order according to ups" do
    topics = Topic.topics_today("hot")
    topics.collect{|t| t}.should eq [@a[1], @a[0]] 
  end

  it "gets all the hot subreddit topics for the day in descending order according to ups" do
    topics = Topic.topics_today("pics")
    topics.collect{|t| t}.should eq [@a[1], @a[2]] 
  end
end
