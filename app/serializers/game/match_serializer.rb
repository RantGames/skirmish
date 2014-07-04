class Skirmish::MatchSerializer < ActiveModel::Serializer
  attributes :id
  has_many :players
end
