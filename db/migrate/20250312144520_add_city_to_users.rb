class AddCityToUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :location, :address
    add_column :events, :city, :string
    add_column :events, :country, :string
  end
end
