class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :shop_id
      t.string :name
      t.text :sizes

      t.timestamps null: false
    end
  end
end
