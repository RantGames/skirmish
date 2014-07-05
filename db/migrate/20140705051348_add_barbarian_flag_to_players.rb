class AddBarbarianFlagToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :barbarian, :boolean, default: false
  end
end
