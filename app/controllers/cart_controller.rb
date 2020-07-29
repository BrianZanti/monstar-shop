class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    if cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart"
    else
      flash[:error] = "#{item.name} does not have enough inventory to satisfy your request"
    end
    redirect_to cart_path
  end

  def show
    render file: "#{Rails.root}/public/404.html", status: 404 if current_admin?
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end


end
