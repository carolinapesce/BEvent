class RemoveUserIdFromCarts < ActiveRecord::Migration[8.0]
  def change
    remove_column :carts, :user_id, :integer
  end
end
