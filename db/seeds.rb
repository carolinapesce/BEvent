# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Faker::Config.locale = 'it'


NUM_USERS = 20
NUM_EVENTS = 30

users = NUM_USERS.times.map do |i|
  email = "user#{i+1}@example.com"

  user = User.new(
    email: email,
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.now,
    confirmation_sent_at: Time.now,
    role: rand(0..1)
  )
  if user.save
    users
  else
    nil
  end
end.compact

begin
  NUM_EVENTS.times do |i|
    is_charity_event = [true, false].sample
    data_iniziale = Faker::Time.between(from: '2025-01-01 00:00:00', to: '2025-12-31 23:59:59')
    data_successiva = data_iniziale + rand(1..30).days

    Event.create!(
      title: "Evento #{i+1}",
      description: "Descrizione dell'evento #{i+1}",
      start_datetime: data_iniziale,
      end_datetime: data_successiva,
      address: "Via del #{i+1}, #{i+1}",
      city: "Roma",
      country: "Italia",
      category: ["Concerti", "Festival", "Mostre", "Sport"].sample,
      created_at: Time.now,
      updated_at: Time.now,
      event_type: is_charity_event ? "Beneficenza" : "Evento normale",
      max_participants: rand(10..100),
      current_participants: 0,
      charity_id: is_charity_event ? "charity_#{i + 1}" : nil,  
      beneficiary: is_charity_event ? Faker::Company.name : nil,  
      fundraiser_goal: is_charity_event ? rand(1000.0..5000.0).round(2) : 0.0,  
      current_funds: is_charity_event ? rand(0.0..2000.0).round(2) : 0.0,  
      status: 0, 
      latitude: 41.9028 + rand(-0.1..0.1),  
      longitude: 12.4964 + rand(-0.1..0.1)
    )
  end
end


