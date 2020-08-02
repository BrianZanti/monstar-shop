class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    convert_price * quantity
  end

  def convert_price
    price
      .to_s
      .rjust(2, '0')
      .insert(-3, '.')
      .to_f
  end

  def fulfill
    self.update(fulfilled?: true)
    self.order.check_fulfillment
  end
end
