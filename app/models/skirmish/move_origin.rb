class Skirmish::MoveOrigin < ActiveRecord::Base
  belongs_to :move, class_name: 'Skirmish::Move'
end