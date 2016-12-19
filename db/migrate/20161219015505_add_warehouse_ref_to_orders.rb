class AddWarehouseRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :warehouse, index: true, foreign_key: true
  end
end
