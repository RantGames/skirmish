class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :player, class_name: 'Skirmish::Player'

  def create_player
    self.player = Skirmish::Player.create(name: username)
  end

  def current_game
    if player.present?
      player.game
    else
      nil
    end
  end

  def is_in_a_game?
    current_game != nil
  end

end
