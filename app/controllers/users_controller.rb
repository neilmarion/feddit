class UsersController < ApplicationController
  def create
    #User.create :_id => params[:email]
    #parameters = ActionController::Parameters.new(params)
    #puts parameters
    user = User.create(params.require(:user).permit(:_id))
    UserMailer.subscription_confirmation(user).deliver
    flash[:notice] = "Thank you for subscribing! Please check your email for confirmation."
    redirect_to new_user_path
  end

  def new

  end
end
