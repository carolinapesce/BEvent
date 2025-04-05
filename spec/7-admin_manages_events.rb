require 'rails_helper'

RSpec.describe "Admin Functionality", type: :request do
  let(:admin) { create(:user, role: 2) }
  let!(:events) { create_list(:event, 5) }
  let!(:event) { create(:event) }
  let!(:reviews) { create_list(:review, 3, event: event) }
  let!(:event_to_delete) { create(:event) }
  let!(:event_to_update) { create(:event) }
  let!(:review_to_delete) { create(:review, event: event) }

  before do
    login_as(admin)
  end

  it 'mostra la lista di tutti gli eventi' do
    get admin_events_path
    expect(response).to have_http_status(:success)
    event = events.first
    expect(response.body).to include("Gestione Eventi")
    expect(response.body).to include("#{event.title}")
  end

  it 'elimina un evento' do
    expect {
      delete admin_event_path(event_to_delete)
    }.to change(Event, :count).by(-1)
    expect(response).to redirect_to(admin_events_path)
  end

  it 'modifica un evento' do
    patch admin_event_path(event_to_update), params: { event: { title: 'Updated Event' } }
    expect(event_to_update.reload.title).to eq('Updated Event')
    expect(response).to redirect_to(admin_events_path)
  end

  it 'mostra tutte le recensioni di un evento' do
    get admin_event_reviews_path(event)
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Gestione Recensioni di #{event.title}")
  end

  it 'elimina una recensione' do
    expect {
      delete admin_event_review_path(event, review_to_delete)
    }.to change(Review, :count).by(-1)
    expect(response).to redirect_to(admin_event_reviews_path(event))
  end

  it 'modifica una recensione' do
    patch admin_event_review_path(event, review_to_delete), params: { review: { content: 'Updated review' } }
    expect(review_to_delete.reload.content).to eq('Updated review')
    expect(response).to redirect_to(admin_event_reviews_path(event))
  end
end