class CartItem < ApplicationRecord
  belongs_to :event
  belongs_to :cart

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # calcola il prezzo totale di un singolo evento nel carrello
  def total_price
    if self.event.charity_event? && self.donation_amount.present?
      self.quantity * self.donation_amount
    else
      self.quantity * self.event.event_price
    end
  end
  
end
