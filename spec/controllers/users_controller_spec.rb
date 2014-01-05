require 'spec_helper'

describe UsersController do
  describe "create" do
    let(:subreddits) {['pics', 'programming']} 

    it "successfully creates a user then sends activation email" do
      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_needed_email).once.and_return(mail)

      expect {
        xhr :get, :create, :user => { :_id => "user@email.com", subreddits: subreddits }
        subreddits << "hot"
        assigns(:user).subreddits.should eq subreddits 

        subreddits.each do |subreddit|
          MailingList.where(_id: subreddit).first.emails.collect{|x| x}.should eq [assigns(:user)._id] #weird
        end
      }.to change(User, :count).by 1

      assigns(:user).is_active.should be_nil
    end

    it "activates the user and sends the success subscription email then afterwards sends a daily newsletter from the previous day" do
      user = FactoryGirl.create(:user) 
      token = user.token
      user.is_active.should eq nil 

      mail = mock(mail)
      mail.should_receive(:deliver)
      UserMailer.should_receive(:activation_success_email).once.and_return(mail)

      Topic.should_receive(:email_newsletter_to_user).once

      xhr :get, :activate, :id => user.token
      assigns(:user).token.should_not eq token 
      assigns(:user).is_active.should eq true 

      flash[:notice].should eq I18n.t('user.activation_success')
    end

    it "does not nothing if a user attempts to subscribe again" do
      user = FactoryGirl.create(:user_activated, subreddits: ['pics', 'programming'])
      token = user.token

      xhr :get, :create, :user => { :_id => user._id, :subreddits => ['pics', 'programming'] } 
      assigns(:user).should eq nil

      flash[:notice].should eq "You're already activated."
    end

  end

  it "deactivates a user" do
    user = FactoryGirl.create(:user_activated)
    token = user.token

    mail = mock(mail)
    mail.should_receive(:deliver)
    UserMailer.should_receive(:deactivation_success_email).once.and_return(mail)

    xhr :get, :deactivate, :id => user.token
    assigns(:user).token.should_not eq token 
    assigns(:user).is_active.should eq false


    flash[:notice].should eq "Successfully deactivated."
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
