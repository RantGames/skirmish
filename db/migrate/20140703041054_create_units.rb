class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.belongs_to :player
      t.belongs_to :city
      t.string :unit_type
      t.integer :attack
      t.integer :defense

      t.timestamps
    end
  end
end
