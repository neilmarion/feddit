require 'spec_helper'

describe User do
  it { should_not allow_value("hello").for :_id }

  it "can be activated" do
    user = FactoryGirl.create(:user) 
    MailingList.count.should eq 0
    user.token.should_not eq nil
    token = user.token
    user.is_active.should eq nil
    user.activate!
    user.token.should_not eq token 
    user.is_active.should eq true
  end

  it "can be deactivated" do
    user = FactoryGirl.create(:user_activated)   
    token = user.token
    user.deactivate!
    user.token.should_not eq token
    user.is_active.should eq false 
  end

  it "gets all the active/subscribed users" do
    user = FactoryGirl.create(:user_activated)  
    FactoryGirl.create(:user_deactivated)  
    User.active_users.collect{|x| x}.should eq [user]
  end

  it "token should contain email for the sake of uniqueness" do
    user = FactoryGirl.create(:user_activated)  
    user.token.include?(user._id.gsub(/\.|@/, '')).should eq true
  end
end
