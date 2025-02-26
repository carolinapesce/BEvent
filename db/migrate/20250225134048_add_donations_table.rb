class AddDonationsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :donations do |t|
      t.string :donation_id, null: false
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :amount, null: false, precision: 10, scale: 2, default: 0
      t.timestamps
      t.text :message
      t.boolean :anonymous
    end
  end
end
