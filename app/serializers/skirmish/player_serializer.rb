require 'digest/md5'

class Skirmish::PlayerSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :gravatar_hash
  has_many :cities

  def gravatar_hash
    formatted_email = object.user.present? ? object.user.email.strip.downcase : 'barbarian'
    email_hash = Digest::MD5.hexdigest(formatted_email)
    email_hash
  end
end
