class Skirmish::City < ActiveRecord::Base
  has_many :units, class_name: 'Skirmish::Unit'
  belongs_to :player, class_name: 'Skirmish::Player'
end
