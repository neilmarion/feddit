require 'spec_helper'

describe UsersController do
  describe "create" do
    let(:subreddits) {['pics', 'programming']} 

    it "successfully creates a user then sends activation email" do
      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_needed_email).once.and_return(mail)

      expect {
        expect {
          xhr :get, :create, :user => { :_id => "user@email.com", subreddits: subreddits }
          subreddits << "hot"
          assigns(:user).subreddits.should =~ subreddits 

        }.to change(User, :count).by 1
      }.to_not change(MailingList, :count)


      assigns(:user).is_active.should be_nil
    end

    it "activates the user and sends the success subscription email then afterwards sends a daily newsletter from the previous day" do
      user = FactoryGirl.create(:user, subreddits: ['hot', 'pics', 'programming']) 
      token = user.token
      user.is_active.should eq nil 

      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_success_email).once.and_return(mail)

      Topic.should_receive(:email_newsletter_to_user).once

      xhr :get, :activate, :id => user.token
      assigns(:user).token.should_not eq token 
      assigns(:user).is_active.should eq true 

      subreddits.each do |subreddit|
        MailingList.where(_id: subreddit).first.emails.collect{|x| x}.should eq [assigns(:user)._id] #weird
      end

      flash[:notice].should eq I18n.t('user.activation_success')
    end

    it "does not nothing if a user attempts to subscribe again (with the same subreddits)" do
      user = FactoryGirl.create(:user_activated, subreddits: ['pics', 'programming', 'hot'])
      token = user.token
      xhr :get, :create, :user => { :_id => user._id, :subreddits => ['pics', 'programming'] } 

      flash[:notice].should eq "You're already activated."
    end

    it "subscribes user to other mailing list if user subscribed with different sets of subreddits" do
      user = FactoryGirl.create(:user_activated, subreddits: ['pics', 'programming'])
      token = user.token

      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:subscription_success_email).once.and_return(mail)


      xhr :get, :create, :user => { :_id => user._id, :subreddits => ['gifs',] } 
      assigns(:user).subreddits.should =~ ['pics', 'programming', 'hot', 'gifs']

      flash[:notice].should eq "Successfully subscribed."
    end

  end

  it "deactivates a subscription for a user" do
    user = FactoryGirl.create(:user_activated)
    token = user.token
    is_active = user.is_active
    is_active.should eq true
    user.subreddits.should_not be :blank

    user.subreddits.each do |subreddit|
      MailingList.where(_id: subreddit).first.emails.should include user._id
    end

    MailingList.count.should >= user.subreddits.count

    mail = mock(mail)
    mail.should_receive(:deliver)
    UserMailer.should_receive(:deactivation_success_email).once.and_return(mail)

    subreddit = user.subreddits.first

    xhr :get, :deactivate, :id => user.token, :subreddit => subreddit
    assigns(:user).token.should_not eq token 
    assigns(:user).is_active.should eq true 
    MailingList.where(_id: subreddit).first.emails.should_not include user.id
    user.subreddits.should_not include user.id

    flash[:notice].should eq "Successfully unsubscribed."
  end

  it "deactivates a user if no subreddits remaining being subscribed to" do
    user = FactoryGirl.create(:user_activated, subreddits: ["pics"])
    token = user.token
    is_active = user.is_active
    is_active.should eq true
    user.subreddits.should_not be_empty 

    user.subreddits.each do |subreddit|
      MailingList.where(_id: subreddit).first.emails.should include user._id
    end

    MailingList.count.should >= user.subreddits.count

    mail = mock(mail)
    mail.should_receive(:deliver)
    UserMailer.should_receive(:deactivation_success_email).once.and_return(mail)

    subreddit = user.subreddits.first

    xhr :get, :deactivate, :id => user.token, :subreddit => subreddit
    assigns(:user).token.should_not eq token 
    assigns(:user).is_active.should eq false 
    MailingList.where(_id: subreddit).first.emails.should_not include user._id
    assigns(:user).subreddits.should be_blank

    flash[:notice].should eq "Successfully unsubscribed."
  end

  it "subscribes a user on a subreddit" do
    subreddit = SUBREDDITS.first
    user = FactoryGirl.create(:user_no_subscription)
    token = user.token
    is_active = user.is_active
    is_active.should eq true
    user.subreddits.should be_empty

    MailingList.count.should eq 0

    mail = mock(mail)
    mail.should_receive(:deliver)
    UserMailer.should_receive(:subscription_success_email).once.and_return(mail)

    xhr :get, :subscribe, :id => user.token, :subreddits => [subreddit]
    assigns(:user).token.should_not eq token 
    assigns(:user).is_active.should eq true 
    MailingList.where(_id: subreddit).first.emails.should include user.id
    assigns(:user).subreddits.should include subreddit 

    flash[:notice].should eq "Successfully subscribed."
 
  end


  it "does not nothing if a subscribed user subscribes again" do
    user = FactoryGirl.create(:user_activated)
    token = user.token

    xhr :get, :activate, :id => user.token
    assigns(:user).token.should eq token 
    assigns(:user).is_active.should eq true 

    flash[:notice].should eq "You're already activated."
  end

  it "does not nothing if a unsubscribed user unsubscribes again" do
    user = FactoryGirl.create(:user_deactivated)
    token = user.token

    xhr :get, :deactivate, :id => user.token
    assigns(:user).token.should eq token 
    assigns(:user).is_active.should eq false 

    flash[:notice].should eq "You're already deactivated."
  end


  it "does not nothing if wrong activation token" do
    user = FactoryGirl.create(:user_activated)
    token = user.token

    xhr :get, :activate, :id => "wrong token"
    assigns(:user).should be nil

    flash[:notice].should eq "Something's wrong! Your activation token just expired."
  end

  it "does not nothing if wrong deactivation token" do
    user = FactoryGirl.create(:user_activated)
    token = user.token

    xhr :get, :deactivate, :id => "wrong token"
    assigns(:user).should be nil

    flash[:notice].should eq "Something's wrong! Your activation token just expired."
  end


  it "activates the user and sends the success subscription email" do
    user = FactoryGirl.create(:user_deactivated) 
    token = user.token
    user.is_active.should eq false 

    mail = mock(mail)
    mail.should_receive(:deliver)
    UserMailer.should_receive(:activation_success_email).once.and_return(mail)

    xhr :get, :activate, :id => user.token
    assigns(:user).token.should_not eq token 
    assigns(:user).is_active.should eq true 

    flash[:notice].should eq "Successfully activated."
  end

end
