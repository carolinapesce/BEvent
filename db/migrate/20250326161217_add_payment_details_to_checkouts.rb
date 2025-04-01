class AddPaymentDetailsToCheckouts < ActiveRecord::Migration[8.0]
  def change
    add_column :checkouts, :stripe_session_id, :string
    add_column :checkouts, :total_amount, :integer
    add_column :checkouts, :completed_at, :datetime
  end
end
