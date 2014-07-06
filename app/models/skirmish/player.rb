class Skirmish::Player < ActiveRecord::Base
  has_many :cities, class_name: 'Skirmish::City'
  has_many :moves, class_name: 'Skirmish::Move'
  belongs_to :game, class_name: 'Skirmish::Game'
  has_one :user
end
