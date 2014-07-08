class MakeTurnCompletedFalseByDefault < ActiveRecord::Migration
  def change
    change_column :turns, :completed, :boolean, default: false
  end
end
