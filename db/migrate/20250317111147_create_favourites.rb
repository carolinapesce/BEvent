class CreateFavourites < ActiveRecord::Migration[8.0]
  def change
    create_table :favourites do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: true
      t.references :event, null:false, foreign_key: true
    end
  end
end
