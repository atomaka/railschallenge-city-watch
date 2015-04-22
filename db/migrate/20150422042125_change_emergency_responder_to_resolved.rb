class ChangeEmergencyResponderToResolved < ActiveRecord::Migration
  def change
    rename_column :emergencies, :responder_at, :resolved_at
  end
end
