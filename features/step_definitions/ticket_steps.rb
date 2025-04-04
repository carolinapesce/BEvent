Given("esiste un evento pubblico disponibile") do
  @event = FactoryBot.create(:event)
end

Given("esiste un utente registrato") do
  @user = FactoryBot.create(:user)
end

Given("l’utente ha effettuato l’accesso") do
  login_as(@user, scope: :user)
end

When("visita la pagina dell’evento") do
  visit event_path(@event)
end

When("clicca su {string}") do |button|
  click_on button
end

When("inserisce i dati della carta e conferma") do
  fill_in "Card Number", with: "4242424242424242"
  fill_in "Expiry", with: "12/30"
  fill_in "CVC", with: "123"
  click_on "Paga ora"
end

Then("il biglietto è creato nel suo account") do
  expect(@user.tickets.count).to eq(1)
end

Then("vede il riepilogo della transazione") do
  expect(page).to have_content("Pagamento completato con successo!")
  expect(page).to have_content("Dettagli dell'ordine")
  expect(page).to have_content(@event.title)
  expect(page).to have_content("Quantità")
  expect(page).to have_content("Totale")
end