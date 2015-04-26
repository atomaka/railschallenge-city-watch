class RemoveEmergencyIdFromResponders < ActiveRecord::Migration
  def change
    remove_column :responders, :emergency_id
  end
end
