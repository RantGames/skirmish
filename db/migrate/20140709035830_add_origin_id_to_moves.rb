class AddOriginIdToMoves < ActiveRecord::Migration
  def change
    add_column(:moves, :origin_id, :integer)
  end
end
