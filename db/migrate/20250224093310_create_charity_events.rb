class CreateCharityEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :charity_events do |t|
      t.timestamps
    end
  end
end
