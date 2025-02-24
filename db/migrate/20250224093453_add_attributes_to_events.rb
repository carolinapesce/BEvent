class AddAttributesToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :max_participants, :integer
    rename_column :events, :participants, :current_participants
    add_column :events, :charity_id, :string
    add_column :events, :beneficiary, :string
    add_column :events, :fundraiser_goal, :decimal, precision: 10, scale: 2
    add_column :events, :current_funds, :decimal, precision: 10, scale: 2, default: 0
  end
end
