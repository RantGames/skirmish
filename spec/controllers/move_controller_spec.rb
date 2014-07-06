require 'rails_helper'
require 'skirmish/factories'

describe MoveController, :type => :controller do
  before do
    @game = Skirmish::Game.create
    @game.players = [Skirmish::Factories::Player.make(user_id: 1), Skirmish::Factories::Player.make(user_id: 2)]
    @game_state = Skirmish::GameState.new(@game)
    p1 = @game.players[0]
    p1.user_id = 1
    @p1_id = p1.id
    @p2_id = @game.players[1].id
    sign_in double('user', id: 1)
  end

  describe 'entering a move', slow: true do
    before do
      @move = {
               player_id: @p1_id,
               action: Skirmish::Move::MOVE_UNIT,
               origin_ids: [@game_state.units_for_player(@p1_id).first.id],
               target_id: @game_state.cities_for_player(@p1_id).last.id
              }
    end

    context 'move is valid' do
      before do
        post 'create', {game_id: @game.id, move: @move.to_json}
      end

      it 'returns 200 OK' do
        expect(response).to be_success
      end

      it 'returns a success message' do
        expect(response.body).to match(/.*message.*/)
      end

      it 'creates the move in the correct turn' do
        most_recent_move = Skirmish::Move.order('created_at DESC').limit(1).first
        most_recent_turn = Skirmish::Turn.order('created_at DESC').limit(1).first

        expect(most_recent_move.turn_id).to eq(most_recent_turn.id)
      end
    end

    context 'move is invalid' do
      before do
        @move[:target_id] = @game_state.cities_for_player(@p2_id).last.id
        post 'create', {game_id: @game.id, move: @move.to_json}
      end

      it 'returns 422 Unprocessable Entity' do
        expect(response.status).to eq(422)
      end

      it 'returns an error message' do
        expect(response.body).to match(/.*Error occurred processing move.*/)
      end
    end
  end
end