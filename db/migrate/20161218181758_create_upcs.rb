class CreateUpcs < ActiveRecord::Migration
  def change
    create_table :upcs do |t|
      t.integer :code
      t.string :name

      t.timestamps null: false
    end
  end
end
