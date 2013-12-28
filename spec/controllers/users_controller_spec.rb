require 'spec_helper'

describe UsersController do
  describe "create" do
    it "successfully creates a user" do
      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:subscription_confirmation).once.and_return(mail)

      expect {
        xhr :get, :create, :user => { :email => "user@email.com" }
      }.to change(User, :count).by 1
    end
  end
end
