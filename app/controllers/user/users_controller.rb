class User::UsersController < User::BaseController
  def show
  end

  def edit
  end

  def update
    current_user.update(user_params)
    flash[:success] = 'Your profile has been updated.'
    redirect_to profile_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip)
  end
end
