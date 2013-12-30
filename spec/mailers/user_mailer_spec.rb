require 'spec_helper'

describe UserMailer do
  describe "subscription_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.subscription_confirmation(user) }

    it "sends confirmation url email" do
      mail.subject.should eq("Confirm Subscription")
      mail.to.should eq([user._id])
      mail.from.should eq(["subscribe@fedd.it"])
    end
  end
end
