class Skirmish::MoveOrigin < ActiveRecord::Base
  belongs_to :move, class_name: 'Skirmish::Move'

  validate :origin_id_is_existing_unit

private
  def origin_id_is_existing_unit
    unless Skirmish::Unit.exists? id: origin_id
      errors[:origin_id] << "Origin id (#{origin_id} does not point to valid unit"
    end
  end
end