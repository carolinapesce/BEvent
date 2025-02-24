class ModifyTicketsTable < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :booked_datetime, :datetime
    add_reference :tickets, :event, foreign_key: true
    add_index :tickets, [:user_id, :event_id], unique: true 
  end
end
