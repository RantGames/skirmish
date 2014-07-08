class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players, class_name: 'Skirmish::Player'

  def create_player
    player = Skirmish::Player.create( name: username)
    self.players << player
    player
  end

  def current_game
    if players.present?
      current_player.game
    else
      nil
    end
  end

  def current_player
    players.order(:game_id).last
  end

  def is_in_a_game?
    current_game != nil
  end

end

