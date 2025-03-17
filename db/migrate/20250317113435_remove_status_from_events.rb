class RemoveStatusFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :status, :integer
  end
end
