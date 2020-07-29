class User::UsersController < User::BaseController
  def show
  end

  def edit
  end

  def update
    user = current_user
    if user.update(user_params)
      flash[:success] = 'Your profile has been updated.'
      redirect_to profile_path
    else
      flash[:error] = user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip)
  end
end
