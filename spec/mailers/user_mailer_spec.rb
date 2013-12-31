require 'spec_helper'

describe UserMailer do
  describe "subscription_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail_activate) { UserMailer.activation_success_email(user) }
    let(:mail_confirmation) { UserMailer.activation_needed_email(user) }
    let(:mail_deactivate) { UserMailer.deactivation_success_email(user) }

    it "sends confirmation url email" do
      mail_confirmation.subject.should eq("Welcome")
      mail_confirmation.to.should eq([user._id])
      mail_confirmation.from.should eq(["subscribe@fedd.it"])
    end

    it "sends success activation email" do
      mail_activate.subject.should eq("Thanks for Subscribing")
      mail_activate.to.should eq([user._id])
      mail_activate.from.should eq(["subscribe@fedd.it"])
    end

    it "sends success deactivation email" do
      mail_deactivate.subject.should eq("So sad! You have unsubscribed.")
      mail_deactivate.to.should eq([user._id])
      mail_deactivate.from.should eq(["subscribe@fedd.it"])
    end
  end
end
