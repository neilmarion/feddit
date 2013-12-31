class UsersController < ApplicationController
  def create
    @user = User.create(params.require(:user).permit(:_id))
    UserMailer.activation_needed_email(@user).deliver
    flash[:notice] = "Thank you for subscribing! Please check your email for confirmation."
    redirect_to new_user_path
  end

  def new
  end

  def activate
    if (@user = User.find_by(token: params[:id]))
      @user.activate!
      UserMailer.activation_success_email(@user).deliver
      redirect_to(new_user_path, :notice => 'Successfully activated.')
    else
      #error here
    end
  end

  def deactivate
    if (@user = User.find_by(token: params[:id]))
      @user.deactivate!
      UserMailer.deactivation_success_email(@user).deliver
      redirect_to(new_user_path, :notice => 'Successfully deactivated.')
    else
      #error here
    end
  end
end
