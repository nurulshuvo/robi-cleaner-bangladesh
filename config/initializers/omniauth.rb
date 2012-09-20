Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['app_id'], ENV['app_secret'],
  :scope => "email, publish_stream, publish_actions, read_friendlists, user_status, user_likes "
end