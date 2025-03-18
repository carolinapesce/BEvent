FactoryBot.define do
  factory :user do {
    email {Faker::Internet.email}
    password {"password123"}
    role { 0 }
    created_at { Time.current }
    updated_at { Time.current }

    trait :eventplanner do
      role { 1 }
    end

    trait :admin do
      role { 2 }
    end


  }
end
