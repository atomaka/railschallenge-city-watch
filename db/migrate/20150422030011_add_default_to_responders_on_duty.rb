class AddDefaultToRespondersOnDuty < ActiveRecord::Migration
  def change
    change_column :responders, :on_duty, :boolean, default: false
  end
end
