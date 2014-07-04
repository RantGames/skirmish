require 'pusher'

Pusher.key = "013b1cfdc9072c8dbe04"
Pusher.secret = ENV["PUSHER_SECRET"]
Pusher.app_id = "80355"

Pusher.logger = Rails.logger

