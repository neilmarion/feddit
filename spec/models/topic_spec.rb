require 'spec_helper'

describe Topic do
  before :each do
    @a = [FactoryGirl.create(:topic, ups: 8),
      FactoryGirl.create(:topic, ups: 10),
      FactoryGirl.create(:topic, ups: 9)]
  end

  it "gets all the topics for the day in descending order according to ups" do
    topics = Topic.topics_today
    topics.collect{|t| t}.should eq [@a[1], @a[2], @a[0]] 
  end
end
