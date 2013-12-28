require 'spec_helper'

describe UserMailer do
  describe "subscription_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.subscription_confirmation(user) }
    let(:mail) { UserMailer.activation_needed_email(user) }

    it "sends confirmation url email" do
      mail.subject.should eq("Welcome")
      mail.to.should eq([user._id])
      mail.from.should eq(["noreply@fedd.it"])
      #mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end
