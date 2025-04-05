require 'rails_helper'

RSpec.describe Ticket, type: :model do

  it "crea un biglietto dopo il pagamento confermato" do
    user = create(:user)
    event = create(:event)

    allow(Stripe::Charge).to receive(:create).and_return({id: "ch_1Hk60A2eZvKYlo2C6p8tRHm5"})

    expect {
      create(:ticket, user_id: user.id, event_id: event.id)
    }.to change { user.tickets.count }.by(1)
  end

  it "associa correttamente un biglietto all'utente" do
    user = create(:user)
    event = create(:event)

    ticket = create(:ticket, user: user, event: event)

    expect(ticket.user).to eq(user)
    expect(ticket.event).to eq(event)
  end

  describe 'validazioni dell\'ordine' do
    it 'verifica che i dati dell\'ordine siano validi prima dell\'invio a Stripe' do
      user = create(:user)
      event = create(:event)

      ticket = build(:ticket, user: user, event: event)

      expect(ticket).to be_valid
    end

    it 'verifica che il biglietto non venga creato senza un utente valido' do
      event = create(:event)

      ticket = build(:ticket, user: nil, event: event)

      expect(ticket).to_not be_valid
    end

    it 'verifica che il biglietto non venga creato senza un evento valido' do
      user = create(:user)

      ticket = build(:ticket, user: user, event: nil)

      expect(ticket).to_not be_valid
    end
  end
end

