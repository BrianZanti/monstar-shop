class User::OrdersController < User::BaseController
  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    order = Order.find(params[:id])
    order.cancel
    redirect_to profile_order_path(order)
  end
end
