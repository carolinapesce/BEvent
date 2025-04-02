class CreateSupports < ActiveRecord::Migration[8.0]
  def change
    create_table :supports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject
      t.text :message
      t.text :response

      t.timestamps
    end
  end
end
