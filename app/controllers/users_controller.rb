class UsersController < ApplicationController
  def create
    begin 
      params[:user][:subreddits] << "hot" #hot is default
      @user = User.create(params.require(:user).permit(:_id, :subreddits => []))
      UserMailer.activation_needed_email(@user).deliver
      flash[:notice] = I18n.t('user.check_email') 
      redirect_to new_user_path
    rescue Moped::Errors::OperationFailure
      redirect_to(new_user_path, :notice => I18n.t('user.activation_redundant'))
    end
  end

  def new
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

  def deactivate
    begin
      @user = User.find_by(token: params[:id])

      if (@user && (@user.is_active == true))
        @user.deactivate!
        UserMailer.deactivation_success_email(@user).deliver
        redirect_to(new_user_path, :notice => I18n.t('user.deactivation_success'))
      else
        redirect_to(new_user_path, :notice => I18n.t('user.deactivation_redundant'))
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to(new_user_path, :notice => I18n.t('user.token_expired'))
    end
  end
end
