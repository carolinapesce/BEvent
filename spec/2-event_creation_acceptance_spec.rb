require 'rails_helper'

RSpec.describe 'Creazione evento', type: :feature, js: true do
  let!(:organizer) { create(:user, role: 1) } 

  before do
    sign_in :organizer
  end

  it 'Un organizzatore autenticato può creare un evento inserendo tutti i dettagli richiesti' do
    visit root_path

    fill_in 'Inserisci la tua email', with: organizer.email
    fill_in 'Inserisci la tua password', with: 'password' 
    click_button 'Log in'

    visit new_event_path
  
    fill_in 'Titolo', with: 'Concerto Rock'
    select 'Musica', from: 'Categoria'
    select_datetime('event_start_datetime', with: 3.days.from_now)
    select_datetime('event_end_datetime', with: 3.days.from_now + 2.hours)
    fill_in 'Numero massimo di partecipanti', with: 100
    fill_in 'Indirizzo', with: 'Via Roma 10'
    fill_in 'Città', with: 'Milano'
    fill_in 'Paese', with: 'Italia'
    fill_in 'Descrizione', with: 'Concerto all’aperto con band locali'

    click_button 'Next' 

    click_button 'Next' 

    fill_in 'event_price', with: 20
    #uncheck 'Evento di beneficienza?'
    click_button 'Next' 

    click_button 'Salva'

    expect(page).to have_content('Trova gli eventi perfetti per te!')
  end

  it 'Dopo la creazione, l’evento di beneficenza appare nell’elenco degli eventi disponibili' do
    visit root_path
  
    fill_in 'Inserisci la tua email', with: organizer.email
    fill_in 'Inserisci la tua password', with: 'password'
    click_button 'Log in'
  
    visit new_event_path
  
    fill_in 'Titolo', with: 'Concerto di beneficenza'
    select 'Musica', from: 'Categoria'
    select_datetime('event_start_datetime', with: 3.days.from_now)
    select_datetime('event_end_datetime', with: 3.days.from_now + 2.hours)
    fill_in 'Numero massimo di partecipanti', with: 100
    fill_in 'Indirizzo', with: 'Piazza del Popolo'
    fill_in 'Città', with: 'Roma'
    fill_in 'Paese', with: 'Italia'
    fill_in 'Descrizione', with: 'Evento musicale di raccolta fondi per beneficenza'
  
    click_button 'Next' 
    click_button 'Next'
  
    check 'charity_event_checkbox' 

    find('#beneficiary_field', visible: :visible, wait: 5).set('Associazione Benefica')
    find('#fundraiser_goal_field', visible: :visible, wait: 5).set(10000)

    click_button 'Next' 
  
    click_button 'Salva'
  
    expect(page).to have_content('Trova gli eventi perfetti per te!')
  
    visit events_search_path(category: 'Musica')
    page.execute_script <<-JS
      window.google = {
        maps: {
          Map: function() {
            return {
              setCenter: function() {},
              setZoom: function() {}
            };
          }
        }
      };
    JS
    expect(page).to have_selector('#map', visible: :visible, wait: 10)
    sleep(2)
    expect(page).to have_content('Concerto di beneficenza')
  end

  it 'Se mancano dati obbligatori, l’evento non viene creato e viene mostrato un messaggio di errore' do
    visit root_path
    
    fill_in 'Inserisci la tua email', with: organizer.email
    fill_in 'Inserisci la tua password', with: 'password'
    click_button 'Log in'
    
    visit new_event_path
    
    fill_in 'Titolo', with: 'Degustazione di formaggi'
    select 'Food&Drinks', from: 'Categoria'
    select_datetime('event_start_datetime', with: 3.days.from_now)
    select_datetime('event_end_datetime', with: 3.days.from_now + 2.hours)
    fill_in 'Numero massimo di partecipanti', with: 100
    fill_in 'Indirizzo', with: 'Piazza del Popolo'
    
    fill_in 'Paese', with: 'Italia'
    fill_in 'Descrizione', with: 'Degustazione di formaggi squisiti'
    
    click_button 'Next'

    alert = page.driver.browser.switch_to.alert
    
    expect(alert.text).to include("Per favore, compila tutti i campi obbligatori prima di procedere.")
    
    alert.accept
    
    expect(page).to have_current_path(new_event_path)

  end


  def select_datetime(field_id_prefix, with:)
    select with.year.to_s, from: "#{field_id_prefix}_1i"
    select I18n.l(with, format: '%B'), from: "#{field_id_prefix}_2i" 
    select with.day.to_s, from: "#{field_id_prefix}_3i"
    select with.hour.to_s.rjust(2, '0'), from: "#{field_id_prefix}_4i"
    select with.min.to_s.rjust(2, '0'), from: "#{field_id_prefix}_5i"
  end
end