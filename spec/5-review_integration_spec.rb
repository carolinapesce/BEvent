require 'rails_helper'
require 'devise'

RSpec.describe "Gestione delle Recensioni - Integrazione", type: :request do
  let(:user) { create(:user) }
  let(:event) do
    build(:event,
      start_datetime: 3.days.ago,
      end_datetime: 2.days.ago,
      status: :terminated
    ).tap { |e| e.save(validate: false) }
  end
  let(:ticket) { create(:ticket, user: user, event: event) }

  before do
    login_as(user, scope: :user)
  end

  it "salva la recensione nel database e la visualizza nella risposta" do
    ticket = create(:ticket, user: user, event: event)
    expect(ticket.persisted?).to be(true)
    post reviews_path, params: { review: { content: 'Evento fantastico!', rating: 5, event_id: event.id } }

    expect(Review.last.content).to eq('Evento fantastico!')
    expect(Review.last.rating).to eq(5)
    expect(Review.last.event_id).to eq(event.id)

    expect(response).to redirect_to(tickets_path(user))

    follow_redirect!

    expect(response.body).to include("I miei biglietti")
    expect(response.body).to include(event.title)

  end

  it "modifica la recensione e aggiorna correttamente il database" do
    ticket = create(:ticket, user: user, event: event)
    expect(ticket.persisted?).to be(true)
    review = create(:review, user: user, event: event, content: "Recensione iniziale", rating: 4) 
    put review_path(review.id), params: { review: { content: 'Recensione aggiornata', rating: 5 , event_id: event.id } }

    review.reload
    expect(review.content).to eq('Recensione aggiornata')
    expect(review.rating).to eq(5)
  end

  it "elimina la recensione e la rimuove dal database" do
    ticket = create(:ticket, user: user, event: event)
    expect(ticket.persisted?).to be(true)
    review = create(:review, user: user, event: event, content: "Recensione iniziale", rating: 4) 
    delete review_path(review.id)

    expect { review.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(response).to redirect_to(tickets_path(user))
  end

  it "aggiorna correttamente la media delle recensioni dopo aggiunta/modifica/eliminazione" do
    user1 = create(:user)
    ticket1 = create(:ticket, user: user1, event: event)
    expect(ticket1.persisted?).to be(true)
    review1 = create(:review, user: user1, event: event, content: "Recensione iniziale", rating: 4) 
    expect(event.average_rating).to eq(4.0)

    ticket2 = create(:ticket, user: user, event: event)
    expect(ticket2.persisted?).to be(true)

    post reviews_path, params: { review: { content: 'Evento fantastico!', rating: 5, user_id: user.id, event_id: event.id } }
    review2 = Review.find_by(user: user, event: event)
    event.reload
    sleep(2)
    expect(Review.count).to eq(2)
    expect(event.average_rating).to eq(4.5)

    # Modifica una recensione
    put review_path(review2.id), params: { review: { content: 'Recensione aggiornata', rating: 3 , event_id: event.id } }
    review2 = Review.find_by(user: user, event: event)
    review2.reload
    event.reload
    sleep(2)
    expect(event.average_rating).to eq(3.5)

    # Elimina la recensione
    delete review_path(review2.id)
    event.reload
    sleep(2)

    expect(event.average_rating).to eq(4.0)
  end
end