class User::PasswordController < User::BaseController
  def edit
  end

  def update
    current_user.update!(password_params)
    flash[:success] = 'Your password has been updated.'
    redirect_to profile_path
  end

  private
  def password_params
    params.permit(:password, :password_confirmation)
  end
end
