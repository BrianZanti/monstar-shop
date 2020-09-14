class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
    render 'merchant/dashboard/show'
  end
end
