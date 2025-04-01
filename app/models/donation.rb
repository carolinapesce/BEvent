class Donation < ApplicationRecord
    has_one :user
    has_one :event
    #validates :event_must_be_a_charity_event

    def event_must_be_a_charity_event
        error.add(:event,"must be a CharityEvent") unless event.is_a(CharityEvent)
    end

end
