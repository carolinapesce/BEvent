# spec/ticket_purchase_acceptance_spec.rb

require 'rails_helper'

RSpec.describe 'Acquisto del Biglietto', type: :feature do
  let!(:user) do
    User.create(
      email: 'user@gmail.com',
      password: 'password',
      first_name: 'Mario',
      last_name: 'Rossi',
      phone_number: "123456789",
      created_at: Time.current,
      updated_at: Time.current,
      confirmed_at: Time.current,
      stripe_customer_id: 'cus_S4Q00jEyjt6SBS',
      role: 0, 
      blocked: false
    )
  end
  let!(:event) { create(:event) }

  before do
    login_as(user, scope: :user)
    
  end

  context 'quando l’utente è autenticato' do
    it 'verifica che un utente autenticato possa acquistare un biglietto e vederlo nei suoi biglietti' do
      login_as(user, scope: :user)
      # puts "Current user: #{user.inspect}"
      
      visit event_path(event)
      click_button "Aggiungi al carrello"
      click_button "Procedi"
  
      expect(current_path).to match(/^\/c\/pay\//)
      
      allow(Stripe::Charge).to receive(:create).and_return(double(status: 'succeeded'))

      session_id = 'cs_test_a1tiBP6r0VviVTd2K06eAixJo8YO3r88F3iHm7rS83gZ3qynXp3kWDRpI6'
      visit checkouts_success_path(session_id: session_id, event_id: event.id)

      expect(Ticket.count).to eq(1)  
      expect(Ticket.last.user).to eq(user)  
  
      expect(page).to have_content('Esito Transazione')

      visit tickets_path
    
      # Verifica che il biglietto appena acquistato sia visibile nella sezione ordini
      expect(page).to have_content('I miei biglietti')  # Aggiungi il testo che dovrebbe essere presente nell'ordine
      expect(page).to have_content(event.title)  # Verifica che il nome dell'evento sia presente
      expect(page).to have_content('biglietto(i)') # Aggiungi la data dell'acquisto, se applicabile

    end
  end
  
  context 'quando il pagamento fallisce' do
    it 'verifica che l\'acquisto non venga completato e l\'utente riceva un errore' do
      # Login dell'utente
      login_as(user, scope: :user)
      
      # Simulazione della navigazione e aggiunta del biglietto al carrello
      visit event_path(event)
      click_button "Aggiungi al carrello"
      click_button "Procedi"
    
      # Simula il fallimento del pagamento
      # Invece di chiamare Stripe, possiamo simulare una risposta di fallimento
      #allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(double('Session', status: 'failed', id: 'cs_test_a1tiBP6r0VviVTd2K06eAixJo8YO3r88F3iHm7rS83gZ3qynXp3kWDRpI6',amount_total: 5000))
      allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(double('Session', 
        status: 'failed', 
        id: 'cs_test_a1tiBP6r0VviVTd2K06eAixJo8YO3r88F3iHm7rS83gZ3qynXp3kWDRpI6', 
        amount_total: 5000, 
        line_items: double('LineItems', data: [double('LineItem', price: 1000, quantity: 1, description: 'Biglietto Evento X', amount_total: 1000)])))  # Simuliam

      # Visita la rotta di successo, ma in questo caso simula un fallimento
      session_id = 'cs_test_a1tiBP6r0VviVTd2K06eAixJo8YO3r88F3iHm7rS83gZ3qynXp3kWDRpI6'
      visit checkouts_cancel_path(session_id: session_id, event_id: event.id)

      # Verifica che il biglietto non sia stato creato
      expect(Ticket.count).to eq(0)
      
      # Verifica che l'utente riceva un messaggio di errore
      expect(page).to have_content('Pagamento non riuscito')
    end
  end
     

end