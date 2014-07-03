class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :game
      t.bool :moved

      t.timestamps
    end
  end
end
