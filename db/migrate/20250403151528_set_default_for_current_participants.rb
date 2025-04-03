class SetDefaultForCurrentParticipants < ActiveRecord::Migration[8.0]
  def change
    change_column_default :events, :current_participants, 0
  end
end
