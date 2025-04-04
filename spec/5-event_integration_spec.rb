require 'rails_helper'

RSpec.describe "Creazione eventi", type: :request do
  let!(:organizer) { create(:user, role: 1) } 
  
  context "Quando l'organizzatore è autenticato" do
    before do
      post user_session_path, params: {
        user: {
          email: organizer.email,
          password: 'password'
        }
      }
    end

    it "Dopo la creazione, l'evento viene salvato correttamente nel database" do
      event_params = {
        title: "Concerto rock",
        category: "Musica",
        start_datetime: 3.days.from_now,
        end_datetime: 3.days.from_now + 2.hours,
        max_participants: 100,
        address: "Piazza del Popolo",
        city: "Roma",
        country: "Italia",
        description: "Evento musicale rock",
        event_price: 10
      }

      post events_path, params: { event: event_params }

      expect(Event.last.title).to eq("Concerto rock")
      expect(Event.last.city).to eq("Roma")
    end

    it "Dopo la creazione, l'evento è visibile sulla mappa nella sua posizione" do
      event = create(:event, user_id: organizer.id)  
  
      get events_search_path

      expect(response.body).to include(event.address)

      expect(response.body).to include(event.city)
      expect(response.body).to include(event.country)
    end
  end
  
  context "Quando l'organizzatore non è autenticato" do
    it "La creazione dell'evento non è consentita" do
      post events_path, params: { event: { title: 'Concerto', category: 'Musica',  } }

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end