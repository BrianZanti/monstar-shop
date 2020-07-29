class User::PasswordController < User::BaseController
  def edit
  end

  def update
    user = current_user
    if user.update(password_params)
      flash[:success] = 'Your password has been updated.'
      redirect_to profile_path
    else
      flash[:error] = user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private
  def password_params
    params.permit(:password, :password_confirmation)
  end
end
