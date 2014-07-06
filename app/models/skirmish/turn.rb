class Skirmish::Turn < ActiveRecord::Base
  belongs_to :game
  has_many :moves

  def self.add_move(move, game)
    turn = current_turn_for_game(game)
    turn.moves << move

    if game.player_count == turn.moves.count
      Skirmish::Game.process_turn(self)
    end
  end

  def self.current_turn_for_game(game)
    turn = where(game_id: game.id).order('created_at DESC').limit(1).first
    turn ||= Skirmish::Turn.create(game_id: game.id)
    turn
  end
end
