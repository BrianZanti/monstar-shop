class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
    @contents.default = 0
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def add_item(item_id)
    item = Item.find(item_id)
    if item.inventory > count_of(item_id)
      @contents[item_id.to_s] += 1
      return true
    else
      return false
    end
  end

  def decrement_item(item_id)
    new_quantity = @contents[item_id.to_s] -= 1
    @contents.delete(item_id.to_s) if new_quantity == 0
  end

  def total_items
    @contents.values.sum
  end

  def items
    items = Item.where(id: @contents.keys)
    @contents.inject({}) do |item_quantity, (item_id, quantity)|
      item = items.find {|item| item.id.to_s == item_id}
      item_quantity[item] = quantity
      item_quantity
    end
  end

  def subtotal(item)
    item.convert_price * @contents[item.id.to_s]
  end

  def total
    items.sum do |item, quantity|
      item.convert_price * quantity
    end
  end

end
