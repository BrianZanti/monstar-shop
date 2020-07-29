class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def convert_price
    price
      .to_s
      .rjust(2, '0')
      .insert(-3, '.')
      .to_f
  end

  def self.by_quantity_sold(direction: 'desc', limit: 5)
    left_joins(:item_orders)
      .select('items.*, sum(COALESCE(quantity, 0)) as quantity_sold')
      .where(active?: true)
      .group(:id)
      .order("quantity_sold #{direction}")
      .limit(limit)
  end
end
