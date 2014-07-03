class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.belongs_to :player
      t.belongs_to :turn
      t.string :action
      t.int :target_id
      t.int :origin_id

      t.timestamps
    end
  end
end
