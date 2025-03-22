class AddEventPriceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :event_price, :integer
  end
end
