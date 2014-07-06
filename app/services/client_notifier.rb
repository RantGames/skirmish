class ClientNotifier

  def push_state_notice
    Pusher.trigger('skirmish_channel','update_state', { message: 'pull_game_state'})
  end

end
