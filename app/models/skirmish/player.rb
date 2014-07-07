require 'active_record_ignored_attributes'

class Skirmish::Player < ActiveRecord::Base
  has_many :cities, class_name: 'Skirmish::City', dependent: :destroy
  has_many :moves, class_name: 'Skirmish::Move', dependent: :destroy
  belongs_to :game, class_name: 'Skirmish::Game'
  has_one :user

  def self.ignored_attributes
    super + [:game_id]
  end

  def ==(other)
    return false unless other.is_a? Skirmish::Player

    return false unless other.same_as?(self)
    other.cities == cities
  end
end
