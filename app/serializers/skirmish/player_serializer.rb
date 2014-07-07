class Skirmish::PlayerSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id
  has_many :cities
end
