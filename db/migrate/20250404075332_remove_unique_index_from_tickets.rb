class RemoveUniqueIndexFromTickets < ActiveRecord::Migration[8.0]
  def change
    remove_index :tickets, name: "index_tickets_on_user_id_and_event_id"
  end
end
