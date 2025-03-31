class AddUnlockableToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :unlock_token, :string
    add_column :users, :unlock_sent_at, :datetime
  end
end
