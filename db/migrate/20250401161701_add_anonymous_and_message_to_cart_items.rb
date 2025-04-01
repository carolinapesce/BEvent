class AddAnonymousAndMessageToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_column :cart_items, :anonymous, :boolean
    add_column :cart_items, :message, :text
  end
end
