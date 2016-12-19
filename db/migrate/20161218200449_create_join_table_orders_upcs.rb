class CreateJoinTableOrdersUpcs < ActiveRecord::Migration
  def change
    create_join_table :orders, :upcs do |t|
      # t.index [:order_id, :upc_id]
      # t.index [:upc_id, :order_id]
    end
  end
end
