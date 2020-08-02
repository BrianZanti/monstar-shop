class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: [:pending, :packaged, :shipped, :cancelled]

  def grandtotal
    cents = item_orders.sum('price * quantity')
    cents / 100.0
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def cancel
    self.update(status: :cancelled)
    item_orders.update(fulfilled?: false)
  end

  def check_fulfillment
    if item_orders.where(fulfilled?: false).empty?
      self.update(status: :packaged)
      return true
    else
      return false
    end
  end
end
