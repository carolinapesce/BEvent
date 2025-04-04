require 'rails_helper'

RSpec.describe Ticket, type: :model do

  it "crea un biglietto dopo il pagamento confermato" do
    user = create(:user)
    event = create(:event)

    # Simula un pagamento valido
    allow(Stripe::Charge).to receive(:create).and_return({id: "ch_1Hk60A2eZvKYlo2C6p8tRHm5"})

    # Verifica che il biglietto venga creato solo dopo il pagamento
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
end

RSpec.describe Ticket, type: :model do
  it "non può essere creato con una quantità negativa" do
    user = create(:user)
    event = create(:event)

    ticket = build(:ticket, user: user, event: event, quantity: -1)

    expect(ticket).not_to be_valid
    expect(ticket.errors[:quantity]).to include("must be greater than or equal to 0")
  end
end