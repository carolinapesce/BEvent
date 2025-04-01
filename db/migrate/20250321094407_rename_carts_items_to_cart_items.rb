class RenameCartsItemsToCartItems < ActiveRecord::Migration[8.0]
  def change
    rename_table :carts_items, :cart_items
  end
end
