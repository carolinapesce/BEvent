FactoryBot.define do
  factory :event do
    title { "Concerto Prova" }
    start_datetime { 2.days.from_now }
    end_datetime { start_datetime + 2.hours }
    event_price { 15 }
    address { "Piazza del Popolo" }
    city {"Roma"}
    country {"Italia"}
    max_participants { 30 }
    category { "Musica" }
    stripe_event_id { Faker::Number.number(digits: 8) }
    stripe_price_id { Faker::Number.number(digits: 8) }
  end
end