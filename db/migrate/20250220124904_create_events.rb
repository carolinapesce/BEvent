class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.integer :participants
      t.string :location
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :category
      t.string :status

      t.timestamps
    end
  end
end
