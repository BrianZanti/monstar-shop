class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def count_of(item_id)
    @contents[item_id].to_i
  end

  def add_item(item_id)
    @contents[item_id] = 0 if !@contents[item_id]
    current_quantity = @contents[item_id]
    item = Item.find(item_id)
    if item.inventory > current_quantity
      @contents[item_id] += 1
      return true
    else
      return false
    end
  end

  def decrement_item(item_id)
    new_quantity = @contents[item_id] -= 1
    @contents.delete(item_id) if new_quantity == 0
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.convert_price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).convert_price * quantity
    end
  end

end
