require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { create(:user) }
  
  describe 'Validazioni' do
    it 'è valido con tutti gli attributi richiesti' do
      event = build(:event)
      expect(event).to be_valid
    end

    it 'non è valido senza titolo' do
      event = build(:event, title: nil)
      expect(event).not_to be_valid
    end

    it 'non è valido senza una data di inizio' do
      event = build(:event, start_datetime: nil)
      expect(event).not_to be_valid
    end

    it 'non è valido senza un indirizzo' do
      event = build(:event, address: nil)
      expect(event).not_to be_valid
    end
  end

  describe 'Validazione della data' do
    it 'non consente date di inizio nel passato' do
      event = build(:event, start_datetime: 1.day.ago)
      expect(event).not_to be_valid
    end
  end

end