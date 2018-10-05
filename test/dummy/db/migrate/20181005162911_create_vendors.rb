class CreateVendors < ActiveRecord::Migration[5.2]
  def change
    create_table :vendors do |t|
      t.string :first_name
      t.string :last_name
      t.integer :product_id

      t.timestamps
    end
  end
end
