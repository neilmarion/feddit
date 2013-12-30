require 'spec_helper'

describe UsersController do
  describe "create" do
    it "successfully creates a user then sends activation email" do
      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_needed_email).once.and_return(mail)

      expect {
        xhr :get, :create, :user => { :_id => "user@email.com" }
      }.to change(User, :count).by 1

      assigns(:user).is_active.should be_nil
    end

    it "activates the user and sends the success subscription email" do
      user = FactoryGirl.create(:user) 
      token = user.token
      
      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_success_email).once.and_return(mail)

      xhr :get, :activate, :id => user.token
      assigns(:user).token.should_not eq token 
      assigns(:user).is_active.should eq true 
    end
  end
end
