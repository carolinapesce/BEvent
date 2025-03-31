class Review < ApplicationRecord
  belongs_to :user
  belongs_to :event, counter_cache: true

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  after_commit :update_avg_rating, on: [:create, :update]

  def update_avg_rating
    event.update_average_rating
  end
end
