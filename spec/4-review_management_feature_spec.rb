require 'rails_helper'

RSpec.describe "Gestione delle Recensioni", type: :feature do
  let(:user) { create(:user) }
  let(:event) do
    build(:event,
      start_datetime: 3.days.ago,
      end_datetime: 2.days.ago,
      status: :terminated
    ).tap { |e| e.save(validate: false) }
  end
  
  before do
    visit new_user_session_path
    fill_in 'Inserisci la tua email', with: user.email
    fill_in 'Inserisci la tua password', with: 'password'
    click_button 'Log in'
  end

  it "permette all’utente di recensire solo eventi a cui ha partecipato e che sono terminati" do
    create(:ticket, user: user, event: event)
  
    visit tickets_path

    expect(page).to have_content(event.title)
    expect(page).to have_link('Lascia Recensione')
    click_link 'Lascia Recensione'
    fill_in 'Raccontaci la tua esperienza...', with: 'Bellissimo evento!'
    find("#star_5").click
    click_button 'Invia Recensione'
  
    expect(page).to have_css('.flash.notice', text: 'Recensione inviata con successo')
    expect(page).to have_content('Modifica Recensione')
  end

  it "permette all’utente di modificare una recensione esistente" do
    create(:ticket, user: user, event: event)
    review = create(:review, user: user, event: event, content: "Vecchia recensione", rating: 3)
    
    visit tickets_path
    expect(page).to have_content(event.title)
    click_link 'Modifica Recensione'

    fill_in 'Recensione', with: 'Recensione aggiornata'
    find("#star_4").click
    click_button 'Aggiorna Recensione'

    expect(page).to have_css('.flash.notice', text: 'Recensione aggiornata con successo!')
    expect(page).to have_link('Modifica Recensione')
  end

  it "permette all’utente di eliminare una recensione" do
    create(:ticket, user: user, event: event)
    review = create(:review, user: user, event: event)

    visit tickets_path
    expect(page).to have_content(event.title)
    click_link 'Modifica Recensione'
    click_button 'Elimina'

    expect(page).to have_css('.flash.notice', text: 'Recensione eliminata con successo.')
    expect(page).to have_link('Lascia Recensione')
  end

  it "impedisce all’utente di lasciare più di una recensione per lo stesso evento" do
    create(:ticket, user: user, event: event)
    create(:review, user: user, event: event)

    visit tickets_path
    expect(page).not_to have_button('Invia recensione')
  end
end