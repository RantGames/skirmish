require 'active_record_ignored_attributes'

class Skirmish::City < ActiveRecord::Base
  has_many :units, class_name: 'Skirmish::Unit', dependent: :destroy
  belongs_to :player, class_name: 'Skirmish::Player'

  def self.ignored_attributes
    super + [:player_id]
  end

  def ==(other)
    return false unless other.is_a? Skirmish::City
    return false unless other.same_as?(self)
    other.units == units
  end
end
