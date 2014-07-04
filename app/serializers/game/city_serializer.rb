class Game::CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude, :population
  has_many :units
end
