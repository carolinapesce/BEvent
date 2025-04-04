FactoryBot.define do
  factory :ticket do
    user_id
    event_id
    price { 15 }
    booked_datetime { 2.days.from_now }
    quantity { 1 }
  end
end