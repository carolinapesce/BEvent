class ChangeUserIdColName < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :user_id, :uid
  end
end
