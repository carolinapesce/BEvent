FactoryBot.define do
  factory :review do
    content { "Una recensione di esempio" }
    rating { 5 }
    user
    event
  end
end