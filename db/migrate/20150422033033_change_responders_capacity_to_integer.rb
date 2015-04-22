class ChangeRespondersCapacityToInteger < ActiveRecord::Migration
  def change
    change_column :responders, :capacity, :integer
  end
end
