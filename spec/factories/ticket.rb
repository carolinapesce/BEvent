FactoryBot.define do
  factory :ticket do
    user
    event
    price { 15 }
    booked_datetime { 2.days.from_now }
    quantity { 1 }
  end
end