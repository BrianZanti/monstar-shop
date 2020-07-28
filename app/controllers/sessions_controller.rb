class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    log_in(user)
    flash[:success] = "Welcome #{user.name}, you are now logged in."
    redirect_to profile_path
  end
end
