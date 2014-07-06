require 'active_record_ignored_attributes'

class Skirmish::Unit < ActiveRecord::Base
  belongs_to :city, class_name: 'Skirmish::City'

  def self.ignored_attributes
    super + [:city_id]
  end

  def ==(other)
    return false unless other.is_a? Skirmish::Unit
    other.same_as?(self)
  end
end
