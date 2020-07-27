class Merchant::BaseController < ApplicationController
  before_action :require_merchant

  def require_merchant
    render file: "#{Rails.root}/public/404.html", status: 404 unless current_merchant?
  end
end
