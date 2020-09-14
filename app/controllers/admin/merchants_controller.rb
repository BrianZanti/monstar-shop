class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
    render 'merchant/dashboard/show'
  end

  def index
    @merchants = Merchant.all
    render 'merchants/index'
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    flash[:success] = "#{merchant.name} is now #{merchant.enabled? ? 'enabled' : 'disabled'}."
    redirect_to admin_merchants_path
  end

  private
  def merchant_params
    params.permit(:enabled?)
  end
end
