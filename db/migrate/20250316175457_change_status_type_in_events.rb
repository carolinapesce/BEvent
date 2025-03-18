class ChangeStatusTypeInEvents < ActiveRecord::Migration[8.0]
  def change
    Event.where(status: nil).update_all(status: 0)
    change_column :events, :status, :integer, default: 0, null: false
  end
end
