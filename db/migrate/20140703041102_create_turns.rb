class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.belongs_to :skirmish

      t.timestamps
    end
  end
end
