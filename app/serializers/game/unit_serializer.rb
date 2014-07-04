class Game::UnitSerializer < ActiveModel::Serializer
  attributes :id, :unit_type, :attack, :defense
end
