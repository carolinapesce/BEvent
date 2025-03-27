class AddCartItemToCart < ActiveRecord::Migration[8.0]
  def change
    add_column :carts, :cart_item_id, :integer
  end
end
