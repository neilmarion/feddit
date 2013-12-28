class UsersController < ApplicationController
  def create
    o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
    activation_token = (0...100).map { o[rand(o.length)] }.join

    params['user']['activation_token'] = activation_token 

    user = User.create(params.require(:user).permit(:_id, :activation_token))
    UserMailer.activation_needed_email(user).deliver
    flash[:notice] = "Thank you for subscribing! Please check your email for confirmation."
    redirect_to new_user_path
  end

  def new

  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(new_user_path, :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end
end
