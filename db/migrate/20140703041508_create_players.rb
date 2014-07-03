class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :match
      t.boolean :moved

      t.timestamps
    end
  end
end