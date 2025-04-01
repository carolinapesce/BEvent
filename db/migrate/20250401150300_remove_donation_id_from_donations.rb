class RemoveDonationIdFromDonations < ActiveRecord::Migration[8.0]
  def change
    remove_column :donations, :donation_id
  end
end
