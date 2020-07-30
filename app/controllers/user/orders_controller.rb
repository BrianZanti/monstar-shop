class User::OrdersController < User::BaseController
  def index
    @orders = current_user.orders
  end
end
