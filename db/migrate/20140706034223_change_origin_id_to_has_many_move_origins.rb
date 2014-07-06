class ChangeOriginIdToHasManyMoveOrigins < ActiveRecord::Migration
  def change
    remove_column(:moves, :origin_id)
    create_table :move_origins do |t|
      t.belongs_to :move
      t.integer :origin_id
    end
  end
end
