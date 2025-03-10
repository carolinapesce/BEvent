class AddTicketsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.string :ticket_id, null: false
      t.float :price, null: false
      t.string :seat_number
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
