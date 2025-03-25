class AddStripeFieldsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :stripe_event_id, :string
    add_column :events, :stripe_price_id, :string
  end
end
