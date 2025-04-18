# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

Event.skip_callback(:validate, :before, :start_date_cannot_be_in_the_past)
Event.skip_callback(:validate, :before, :end_date_must_be_after_start_date)

# Admin
User.create!(
  email: "zarola.admin@gmail.com",
  password: "password",
  first_name: "Massimo",
  last_name: "Zarola",
  role: 2,
  id: 1,
  confirmed_at: Time.now
)

User.create!(
  email: "paula.admin@gmail.com",
  password: "password",
  first_name: "Kavidu",
  last_name: "Paula",
  role: 2,
  id: 2,
  confirmed_at: Time.now
)

User.create!(
  email: "pesce.admin@gmail.com",
  password: "password",
  first_name: "Carolina",
  last_name: "Pesce",
  role: 2,
  id: 3,
  confirmed_at: Time.now
)

# Utente normale 
10.times do |i|
  User.create!(
    email: "user#{i + 1}@gmail.com",
    password: "password",
    first_name: "Nome #{i + 1}",
    last_name: "Cognome #{i + 1}",
    role: 0,
    confirmed_at: Time.now
  )
end

# Event planner
10.times do |i|
  User.create!(
    email: "eventplanner#{i + 1}@gmail.com",
    password: "password",
    first_name: "Nome EP #{i + 1}",
    last_name: "Cognome EP #{i + 1}",
    bio: Faker::Lorem.paragraph(sentence_count: 20),
    role: 1,
    confirmed_at: Time.now
  )
end


city_coordinates = {
  "Roma" => [41.9028, 12.4964],
  "Milano" => [45.4642, 9.1900],
  "Napoli" => [40.8522, 14.2681],
  "Torino" => [45.0703, 7.6869],
  "Firenze" => [43.7696, 11.2558]
}

eventplanners = User.where(role: 1)

30.times do |i|
  start_time = Faker::Time.forward(days: rand(1..10), period: [:morning, :afternoon, :evening].sample)
  end_time = start_time + rand(1..[5.hours, (start_time.end_of_day - start_time)].min)
  city = city_coordinates.keys.sample
  latitude, longitude = city_coordinates[city]

  Event.create!(
    title: "Evento #{i + 1}",
    description: "Descrizione dell'evento #{i + 1}",
    current_participants: 0,
    address: "Indirizzo #{i + 1}",
    start_datetime: start_time,
    end_datetime: end_time,
    category: ["Musica", "Sport", "Comedy","Teatro", "Hobby", "Festa", "Arte", "Food&Drinks",].sample,
    event_type: ["Pubblico", "Privato"].sample,
    max_participants: rand(20..100),
    charity_id: nil,
    beneficiary: nil,
    fundraiser_goal: nil,
    current_funds: 0.0,
    city: city,
    country: "Italia",
    status: 0,
    latitude: latitude,
    longitude: longitude,
    event_price: rand(10..50),
    user_id: eventplanners.sample.id,  
    type: nil,  
    charity_event: false,
    stripe_event_id:i+1,
    stripe_price_id: i+1,
    reviews_count: 0
  )
end

30.times do |i|
  start_time = Faker::Time.forward(days: rand(1..10), period: [:morning, :afternoon, :evening].sample)
  end_time = start_time + rand(1..[5.hours, (start_time.end_of_day - start_time)].min)
  city = city_coordinates.keys.sample
  latitude, longitude = city_coordinates[city]

  Event.create!(
    title: "Evento di beneficenza #{i + 1}",
    description: "Descrizione dell'evento di beneficenza #{i + 1}",
    current_participants: 0,
    address: "Indirizzo beneficenza #{i + 1}",
    start_datetime: start_time,
    end_datetime: end_time,
    category: ["Musica", "Sport", "Comedy","Teatro", "Hobby", "Festa", "Arte", "Food&Drinks",].sample,
    event_type: "Beneficenza",
    max_participants: rand(20..100),
    charity_id: "Charity #{i + 1}",
    beneficiary: "Beneficiario #{i + 1}",
    fundraiser_goal: rand(1000..5000),
    current_funds: 0,
    city: city,
    country: "Italia",
    status: 0,
    latitude: latitude,
    longitude: longitude,
    event_price: rand(10..50),
    user_id: eventplanners.sample.id,
    type: "CharityEvent",  
    charity_event: true,
    stripe_event_id:i+1,
    stripe_price_id: i+1,
    reviews_count: 0
  )
end

10.times do |i|
  start_time = Time.now - rand(1..30).days
  end_time = start_time + rand(1..8).hours
  city = city_coordinates.keys.sample
  latitude, longitude = city_coordinates[city]

  event = Event.create!(
    title: "Evento #{i + 1}",
    description: "Descrizione dell'evento #{i + 1}",
    current_participants: 0,
    address: "Indirizzo #{i + 1}",
    start_datetime: start_time,
    end_datetime: end_time,
    category: ["Musica", "Sport", "Comedy","Teatro", "Hobby", "Festa", "Arte", "Food&Drinks",].sample,
    event_type: ["Pubblico", "Privato"].sample,
    max_participants: rand(20..100),
    charity_id: nil,
    beneficiary: nil,
    fundraiser_goal: nil,
    current_funds: 0.0,
    city: city,
    country: "Italia",
    status: 2,
    latitude: latitude,
    longitude: longitude,
    event_price: rand(10..50),
    user_id: eventplanners.sample.id,  
    type: nil,  
    charity_event: false,
    stripe_event_id:i+1,
    stripe_price_id: i+1,
    reviews_count: 0
  )

  reviewers = User.where(role: 0).sample(5)

  reviewers.each do |user|

    cart = Cart.create!(
    )

    cart_item = CartItem.create!(
      cart_id: cart.id,
      event_id: event.id,
      quantity: 1
    )

    Checkout.create!(
      user_id: user.id,
      cart_id: cart.id,
      completed_at: Time.now,
      stripe_session_id: i+1,
      total_amount: event.event_price*100
    )

    Ticket.create!(
      price: event.event_price,
      user_id: user.id,
      event_id: event.id,
      quantity: 1
    )

    Review.create!(
      user_id: user.id,
      event_id: event.id,
      content: Faker::Lorem.paragraph(sentence_count: 10),
      rating: (1..5).to_a.sample
    ) 
  end
end

Event.set_callback(:validate, :before, :start_date_cannot_be_in_the_past)
Event.set_callback(:validate, :before, :end_date_must_be_after_start_date)
