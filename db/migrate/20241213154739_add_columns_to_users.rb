class AddColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :city, :string
    add_column :users, :phone_number, :string
    add_column :users, :uid, :string
    add_column :users, :image_url, :string
    add_column :users, :provider, :string
  end
end
