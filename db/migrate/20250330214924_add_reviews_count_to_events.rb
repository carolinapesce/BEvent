class AddReviewsCountToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :reviews_count, :integer
  end
end
