class CreateCheckouts < ActiveRecord::Migration[8.0]
  def change
    create_table :checkouts do |t|
      t.integer :user_id
      t.integer :cart_id

      t.timestamps
    end
  end
end
