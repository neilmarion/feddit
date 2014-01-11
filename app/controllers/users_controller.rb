class UsersController < ApplicationController
  def create
    user_subreddits_params_with_hot_default
    begin 
      #params[:user][:subreddits] << "hot" #hot is default
      @user = User.create(params.require(:user).permit(:_id, :subreddits => []))
      UserMailer.activation_needed_email(@user).deliver
      flash[:notice] = I18n.t('user.check_email') 
      redirect_to new_user_path
    rescue Moped::Errors::OperationFailure
      @user = User.find_by(_id: params[:user][:_id]) 
      subreddits = params[:user][:subreddits] - @user.subreddits 
      unless subreddits.blank?
        @user.subscribe!(subreddits)
        UserMailer.subscription_success_email(@user, subreddits).deliver
        subreddits.each do |subreddit|
          Topic.email_newsletter_to_user_by_subreddit(@user, subreddit)
        end
        redirect_to(new_user_path, :notice => I18n.t('user.subscription_success'))
      else
        redirect_to(new_user_path, :notice => I18n.t('user.activation_redundant'))
      end
    end
  end

  def new
    @subreddits = SUBREDDITS
    @hot = @subreddits.slice 0
    @subreddits = @subreddits - [@hot] #uggggh!
  end

  def activate
    begin
      @user = User.find_by(token: params[:id])

      if (@user && (@user.is_active == false || @user.is_active == nil))
        @user.activate!
        UserMailer.activation_success_email(@user).deliver
        Topic.email_newsletter_to_user(@user)
        redirect_to(new_user_path, :notice => I18n.t('user.activation_success'))
      else
        redirect_to(new_user_path, :notice => I18n.t('user.activation_redundant'))
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to(new_user_path, :notice => I18n.t('user.token_expired'))
    end
  end

  def subscribe
    begin
      @user = User.find_by(token: params[:id])

      if (@user)
        @user.subscribe!(params[:subreddits])
        UserMailer.subscription_success_email(@user, params[:subreddits]).deliver
        params[:subreddits].each do |subreddit|
          Topic.email_newsletter_to_user_by_subreddit(@user, subreddit)
        end
        redirect_to(new_user_path, :notice => I18n.t('user.subscription_success'))
      else
        redirect_to(new_user_path, :notice => I18n.t('user.subscription_redundant'))
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to(new_user_path, :notice => I18n.t('user.token_expired'))
    end
  end

  def deactivate
    begin
      @user = User.find_by(token: params[:id])

      if (@user && (@user.is_active == true))
        @user.unsubscribe!(params[:subreddit])
        UserMailer.deactivation_success_email(@user, params[:subreddit]).deliver
        redirect_to(new_user_path, :notice => I18n.t('user.deactivation_success'))
      else
        redirect_to(new_user_path, :notice => I18n.t('user.deactivation_redundant'))
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to(new_user_path, :notice => I18n.t('user.token_expired'))
    end
  end

  private

  def user_subreddits_params_with_hot_default
    params[:user][:subreddits].nil? ? params[:user][:subreddits] = ["hot"] : params[:user][:subreddits].unshift("hot")
  end
end
