FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    role { 0 }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    created_at { Time.current }
    updated_at { Time.current }
    confirmed_at { Time.current }

    trait :eventplanner do
      role { 1 }
    end

    trait :admin do
      role { 2 }
    end
  end
end
