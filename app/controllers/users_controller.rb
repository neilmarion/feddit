class UsersController < ApplicationController
  def create
    User.create :_id => params[:email]
  end
end
