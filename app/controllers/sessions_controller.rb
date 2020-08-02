class SessionsController < ApplicationController
  def new
    if current_user
      flash[:info] = "You are already logged in."
      redirect_user
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      log_in(user)
      flash[:success] = "Welcome #{user.name}, you are now logged in."
      redirect_user
    else
      flash[:error] = 'Invalid email or password.'
      render :new
    end
  end

  def destroy
    session.clear
    flash[:success] = 'You are now logged out.'
    redirect_to root_path
  end

  private
  def redirect_user
    redirect_to profile_path if current_user.default?
    redirect_to merchant_dashboard_path if current_user.merchant_employee?
    redirect_to admin_dashboard_path if current_user.admin?
  end
end
