require 'spec_helper'

describe UsersController do
  describe "create" do
    it "successfully creates a user then sends activation email" do
      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_needed_email).once.and_return(mail)

      expect {
        xhr :get, :create, :user => { :email => "user@email.com" }
      }.to change(User, :count).by 1
      User.first.activation_token.should_not be_nil
      User.first.activation_state.should be_nil
    end

    it "activates the user and sends the success subscription email" do
      user = FactoryGirl.create(:user) 

      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_success_email).once.and_return(mail)

      xhr :get, :activate, :id => user.activation_token
      User.first.activation_token.should be_nil
      User.first.activation_state.should eq "active"
    end
  end
end
