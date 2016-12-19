class AddUpcToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :upc, index: true, foreign_key: true
    remove_column :products, :name, :string
  end
end
