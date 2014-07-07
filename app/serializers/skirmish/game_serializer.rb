class Skirmish::GameSerializer < ActiveModel::Serializer
  attributes :id, :winner
  has_many :players
end
