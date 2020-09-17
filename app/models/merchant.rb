class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders?
    pending_orders.any?
  end

  def pending_orders
    orders
      .where(status: :pending)
      .where(item_orders: {fulfilled?: false})
  end

  def quantity_ordered(order)
    item_orders
      .where(order: order)
      .sum(:quantity)
  end

  def revenue_from(order)
    revenue = item_orders
                .where(order: order)
                .sum('item_orders.quantity * item_orders.price')
    revenue / 100.0
  end

  def toggle_enabled
    self.toggle!(:enabled?)
    if self.enabled?
      self.items.update(active?: true)
    else
      self.items.update(active?: false)
    end
  end
end
