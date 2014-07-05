class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :skirmish
      t.string :name

      t.timestamps
    end
  end
end
