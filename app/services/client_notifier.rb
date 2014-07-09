class ClientNotifier

  def self.push_state_notice
    Pusher.trigger('skirmish_channel','update_state', { message: 'pull_game_state'})
  end

  def self.notification(tag, contents, player_id = nil)
    Pusher.trigger('skirmish_channel', 'notification', {
        tag: tag,
        contents: contents,
        time: (Time.now.getutc.to_f * 1000).to_i,
        target_player: player_id
    })
  end
end
