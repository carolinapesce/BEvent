class AddUserIdAndEventIdToFavourites < ActiveRecord::Migration[8.0]
  def change
    add_reference :favourites, :user, null: false, foreign_key: true
    add_reference :favourites, :event, null: false, foreign_key: true
  end
end
