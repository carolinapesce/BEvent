class CreateCartsItems < ActiveRecord::Migration[8.0]
  def change
    create_table :carts_items do |t|
      t.references :cart_id, null: false
      t.references :event_id, null: false
      t.integer :quantity

      t.timestamps
    end
  end
end
