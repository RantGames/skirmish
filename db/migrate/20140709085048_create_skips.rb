class CreateSkips < ActiveRecord::Migration
  def change
    create_table :skips do |t|
      t.belongs_to :turn
      t.belongs_to :player
    end
  end
end
