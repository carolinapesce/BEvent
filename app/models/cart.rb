class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :events, through: :cart_items
  has_one :checkout

  # decrementa la disponibilità dell'evento quando viene aggiunto al carrello
  def decrease_availability
    self.cart_items.each do |cart_item|
      selected_quantity = cart_item.quantity
      cart_item.event.current_participants += selected_quantity
      cart_item.event.save
    end
  end

  # calcola il totale del carrello
  def sub_total
    sum = 0
    self.cart_items.each do |cart_elem|
      if !cart_elem.event.nil?
        sum += cart_elem.total_price
      end
    end
    return sum
  end
  
end
