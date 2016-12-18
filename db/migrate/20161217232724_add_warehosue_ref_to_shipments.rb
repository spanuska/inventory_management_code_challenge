class AddWarehosueRefToShipments < ActiveRecord::Migration
  def change
    add_reference :shipments, :warehouse, index: true, foreign_key: true
  end
end
