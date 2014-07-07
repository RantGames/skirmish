class Skirmish::Turn < ActiveRecord::Base
  belongs_to :game, class_name: 'Skirmish::Game'
  has_many :moves, class_name: 'Skirmish::Move', dependent: :destroy

  def self.add_move(move, game)
    turn = current_turn_for_game(game)
    turn.moves << move

    if game.player_count > 1 && game.player_count == turn.moves.count
      Skirmish::Game.process_turn(turn)
    end
  end

  def self.current_turn_for_game(game)
    turn = where(game_id: game.id).order('created_at DESC').limit(1).first
    turn ||= Skirmish::Turn.create(game_id: game.id)
    turn
  end
end
