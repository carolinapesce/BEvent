class AddAverageRatingToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :average_rating, :decimal
  end
end
