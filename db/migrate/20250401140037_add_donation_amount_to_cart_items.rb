class AddDonationAmountToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_column :cart_items, :donation_amount, :decimal
  end
end
