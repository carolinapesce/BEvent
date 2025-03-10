class CharityEvent < Event
    validates :charity_id, presence: true
    validates :beneficiary, presence: true
    validates :fundraiser_goal, presence: true, numericality: {greater_than_or_equal_to: 0}
    validates :current_funds, presence: ture, numericality: {greater_than_or_equal_to: 0}
end
