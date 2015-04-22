class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.string :type
      t.string :name
      t.string :capacity
      t.boolean :on_duty
      t.integer :emergency_id

      t.timestamps null: false
    end
  end
end
