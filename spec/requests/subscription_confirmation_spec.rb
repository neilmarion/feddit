require 'spec_helper'

describe "Subscription Confirmation" do
  it "emails user after subscribing" do
    visit new_user_path 
    fill_in "user__id", :with => "user@email.com"
    click_button "Subscribe"
    current_path.should eq(new_user_path)
    page.should have_content("Thank you for subscribing! Please check your email for confirmation.")
    last_email.to.should include("user@email.com")
  end
end
