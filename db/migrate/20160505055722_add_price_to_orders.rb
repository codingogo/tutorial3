class AddPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :price, :decimal
  end
end
