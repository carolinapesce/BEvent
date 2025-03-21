Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_MAPS_API_KEY'], # Assicurati che la variabile d'ambiente sia settata
  use_https: true,
  timeout: 10,
  units: :km
)