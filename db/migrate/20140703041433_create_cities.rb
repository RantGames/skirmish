class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.belongs_to :player
      t.float :latitude
      t.float :longitude
      t.int :population_capacity

      t.timestamps
    end
  end
end
