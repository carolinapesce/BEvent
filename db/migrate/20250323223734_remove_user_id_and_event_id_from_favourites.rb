class RemoveUserIdAndEventIdFromFavourites < ActiveRecord::Migration[8.0]
  def change
    remove_column :favourites, :user_id
    remove_column :favourites, :event_id
  end
end
