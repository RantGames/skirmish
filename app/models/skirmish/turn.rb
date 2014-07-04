class Skirmish::Turn < ActiveRecord::Base
  belongs_to :game
  has_many :moves
end
