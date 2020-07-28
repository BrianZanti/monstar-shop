class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      log_in(user)
      flash[:success] = "Welcome #{user.name}, you are now logged in."
      redirect_to profile_path if user.default?
      redirect_to merchant_path if user.merchant_employee?
      redirect_to admin_path if user.admin?
    else
      flash[:error] = 'Invalid email or password.'
      render :new
    end
  end
end
