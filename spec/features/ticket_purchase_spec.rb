require 'rails_helper'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.feature "Acquisto Biglietto", type: :feature do

  scenario "Un utente autenticato acquista un biglietto" do
    let (:user) = create(:user)
    let (:event) = create(:event)

      # Mock della richiesta per creare un cliente su Stripe
   

      stub_request(:post, "https://api.stripe.com/v1/customers").
        with(
          body: hash_including(
            "email" => user.email,
            "address" => {
              "line1" => user.address,  # Via
              "city" => user.city,      # Città
              "country" => "IT"         # Paese
            }
          ),
          headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer sk_test_51R2x4tGoBrbB7mdNhOm6W8bknGC7dEFUV36mTZu1qSinRSKXbMNTztty0hiC9A3LaR3hNaGLbZfSsy5nj4HuAAzN00YM30LsPX',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'Idempotency-Key'=>'5fc2318e-8c9f-40ef-b5c0-74e8a5e661a5',
          'Stripe-Version'=>'2025-02-24.acacia',
          'User-Agent'=>'Stripe/v1 RubyBindings/13.5.0',
          'X-Stripe-Client-User-Agent'=>'{"bindings_version":"13.5.0","lang":"ruby","lang_version":"3.3.6 p108 (2024-11-05)","platform":"arm64-darwin23","engine":"ruby","publisher":"stripe","uname":"Darwin AiFon.guest.local 23.6.0 Darwin Kernel Version 23.6.0: Mon Jul 29 21:13:04 PDT 2024; root:xnu-10063.141.2~1/RELEASE_ARM64_T6020 arm64","hostname":"AiFon.guest.local"}'
        }).
      to_return(status: 200, body: "", headers: {})
    

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    visit event_path(event)
    click_link "Aggiungi al carrello"

    click_button "Procedi"

    # Simula pagamento (in ambiente test puoi mockare la chiamata Stripe)
    fill_in "Numero carta", with: "4242 4242 4242 4242" # Test card di Stripe
    click_button "Conferma pagamento"

    expect(page).to have_content("Pagamento completato con successo!")
    expect(page).to have_content("Dettagli dell'ordine")
    expect(page).to have_content(event.title)
    expect(page).to have_content("Quantità")
    expect(page).to have_content("Totale")

    expect(user.tickets.count).to eq(1)  
    expect(user.tickets.first.event).to eq(event)
  end
end