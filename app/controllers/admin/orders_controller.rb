class Admin::OrdersController < Admin::BaseController
  def update
    order = Order.update(params[:id], order_params)
    redirect_to admin_dashboard_path
  end

  def order_params
    params.permit(:status)
  end
end
