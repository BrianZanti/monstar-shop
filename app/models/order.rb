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
end
