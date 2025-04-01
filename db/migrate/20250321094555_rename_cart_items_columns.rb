class RenameCartItemsColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :cart_items, :cart_id_id, :cart_id
    rename_column :cart_items, :event_id_id, :event_id
  end
end
