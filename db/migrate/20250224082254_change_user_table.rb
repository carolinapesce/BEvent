class ChangeUserTable < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :uid, :user_id
  end
end
