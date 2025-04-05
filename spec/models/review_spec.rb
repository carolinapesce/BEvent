require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  it "crea correttamente una recensione valida" do
    review = Review.new(user: user, event: event, content: "Bella esperienza", rating: 5)
    expect(review.save).to be true
  end

  it "modifica correttamente una recensione" do
    review = create(:review, user: user, event: event, content: "Bella", rating: 4)
    review.update(content: "Esperienza aggiornata", rating: 3)
    review.reload
    expect(review.content).to eq("Esperienza aggiornata")
    expect(review.rating).to eq(3)
  end

  it "elimina correttamente una recensione" do
    review = create(:review, user: user, event: event)
    expect { review.destroy }.to change { Review.count }.by(-1)
  end
  

  it "impedisce all'utente di lasciare più di una recensione per lo stesso evento" do
    create(:review, user: user, event: event)
    duplicate_review = Review.new(user: user, event: event, content: "Altra opinione", rating: 4)

    expect(duplicate_review.valid?).to be false
    expect(duplicate_review.errors[:user_id]).to include("has already been taken")
  end
end