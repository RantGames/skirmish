class AddCompletedToTurns < ActiveRecord::Migration
  def change
    add_column(:turns, :completed, :boolean)
  end
end
