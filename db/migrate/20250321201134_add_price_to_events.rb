class AddPriceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :price, :float, default: 0.0
  end
end
