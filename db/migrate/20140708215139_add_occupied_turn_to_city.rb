class AddOccupiedTurnToCity < ActiveRecord::Migration
  def change
    add_column(:cities, :occupied_turn, :integer)
  end
end
