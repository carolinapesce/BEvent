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

10.times do |i|
  Event.create!(
    title: "Evento #{i + 1}",
    description: "Descrizione dell'evento #{i + 1}",
    current_participants: rand(1..50),
    address: "Indirizzo #{i + 1}",
    start_datetime: Faker::Time.forward(days: rand(1..10), period: :morning),
    end_datetime: Faker::Time.forward(days: rand(1..10), period: :afternoon),
    category: ["Musica", "Sport", "Comedy","Teatro", "Hobby", "Festa", "Arte", "Food&Drinks",].sample,
    event_type: ["Pubblico", "Privato"].sample,
    max_participants: rand(20..100),
    charity_id: nil,
    beneficiary: nil,
    fundraiser_goal: nil,
    current_funds: 0.0,
    city: ["Roma", "Milano", "Napoli", "Torino", "Firenze"].sample,
    country: "Italia",
    status: 0,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    price: rand(10..50),
    user_id: 10,  # Associare all'utente con id 10
    type: nil,  # Non sono eventi di beneficenza, quindi il campo 'type' non è impostato
    charity_event: false
  )
end

10.times do |i|
  Event.create!(
    title: "Evento di beneficenza #{i + 1}",
    description: "Descrizione dell'evento di beneficenza #{i + 1}",
    current_participants: rand(1..50),
    address: "Indirizzo beneficenza #{i + 1}",
    start_datetime: Faker::Time.forward(days: rand(1..10), period: :morning),
    end_datetime: Faker::Time.forward(days: rand(1..10), period: :afternoon),
    category: ["Musica", "Sport", "Comedy","Teatro", "Hobby", "Festa", "Arte", "Food&Drinks",].sample,
    event_type: "Beneficenza",
    max_participants: rand(20..100),
    charity_id: "Charity #{i + 1}",
    beneficiary: "Beneficiario #{i + 1}",
    fundraiser_goal: rand(1000..5000),
    current_funds: rand(100..1000),
    city: ["Roma", "Milano", "Napoli", "Torino", "Firenze"].sample,
    country: "Italia",
    status: 0,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    price: rand(10..50),
    user_id: 10,  # Associare all'utente con id 10
    type: "CharityEvent",  # Evento di beneficenza
    charity_event: true
  )
end