class Checkout < ApplicationRecord
  belongs_to :cart
  belongs_to :user
  
  has_many :cart_items, through: :cart
end