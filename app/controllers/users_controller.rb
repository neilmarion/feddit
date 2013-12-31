class UsersController < ApplicationController
  def create
    begin 
      @user = User.create(params.require(:user).permit(:_id))
      UserMailer.activation_needed_email(@user).deliver
      flash[:notice] = "Thank you for subscribing! Please check your email for confirmation."
      redirect_to new_user_path
    rescue Moped::Errors::OperationFailure
      redirect_to(new_user_path, :notice => "You're already activated.")
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
        redirect_to(new_user_path, :notice => 'Successfully activated.')
      else
        redirect_to(new_user_path, :notice => "You're already activated.")
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to(new_user_path, :notice => "Something's wrong! Your activation token just expired.")
    end
  end

  def deactivate
    begin
      @user = User.find_by(token: params[:id])

      if (@user && (@user.is_active == true))
        @user.deactivate!
        UserMailer.deactivation_success_email(@user).deliver
        redirect_to(new_user_path, :notice => 'Successfully deactivated.')
      else
        redirect_to(new_user_path, :notice => "You're already deactivated.")
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to(new_user_path, :notice => "Something's wrong! Your activation token just expired.")
    end
  end
end
