require 'spec_helper'

describe User do
  it { should_not allow_value("hello").for :_id }

  it "can be activated" do
    user = FactoryGirl.create(:user) 
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
end
