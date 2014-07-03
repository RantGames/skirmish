class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.belongs_to :player
      t.belongs_to :city
      t.string :type
      t.int :attack
      t.int :defense

      t.timestamps
    end
  end
end
