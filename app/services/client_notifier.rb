class ClientNotifier

  def self.push_state_notice
    Pusher.trigger('skirmish_channel','update_state', { message: 'pull_game_state'})
  end

  def self.notification(tag, contents)
    Pusher.trigger('skirmish_channel', 'notification', {
        tag: tag,
        contents: contents,
        time: Time.now.getutc.to_i
    })
  end
end
