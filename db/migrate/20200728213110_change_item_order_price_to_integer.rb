class ChangeItemOrderPriceToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :item_orders, :price, :integer
  end
end
