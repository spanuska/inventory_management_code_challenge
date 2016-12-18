class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.references :allocator, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
