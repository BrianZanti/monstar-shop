class User::BaseController < ApplicationController
  before_action :require_user

  def require_user
    render file: "#{Rails.root}/public/404.html", status: 404 unless current_user
  end
end
