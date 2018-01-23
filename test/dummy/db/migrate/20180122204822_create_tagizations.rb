class CreateTagizations < ActiveRecord::Migration[5.1]
  def change
    create_table :tagizations do |t|
      t.integer :tag_id
      t.integer :product_id

      t.timestamps
    end
  end
end
