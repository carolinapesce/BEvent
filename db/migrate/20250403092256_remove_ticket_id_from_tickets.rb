class RemoveTicketIdFromTickets < ActiveRecord::Migration[8.0]
  def change
    remove_column :tickets, :ticket_id
  end
end
