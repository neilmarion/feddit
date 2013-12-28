require 'spec_helper'

describe UserMailer do
  describe "subscription_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail_success) { UserMailer.activation_success_email(user) }
    let(:mail_confirmation) { UserMailer.activation_needed_email(user) }

    it "sends confirmation url email" do
      mail_confirmation.subject.should eq("Welcome")
      mail_confirmation.to.should eq([user._id])
      mail_confirmation.from.should eq(["noreply@fedd.it"])
    end

    it "sends success subscription email" do
      mail_success.subject.should eq("Thanks for Subscribing")
      mail_success.to.should eq([user._id])
      mail_success.from.should eq(["noreply@fedd.it"])
    end

  end
end
