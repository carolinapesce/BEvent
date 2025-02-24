class AddTypeToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :type, :string
  end
end
