class AddCharityEventToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :charity_event, :boolean, default: false
  end
end
