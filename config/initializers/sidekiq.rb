require 'sidekiq'
require 'sidekiq/web'

if Rails.env.development?
	url = 'redis://localhost:6379/0'
else
	url = ENV['REDISTOGO_URL']
end

Sidekiq.default_worker_options = { 'backtrace' => true }

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ['john', 'loislane']
end

Sidekiq.configure_server do |config|
	Rails.logger = Sidekiq::Logging.logger
  config.redis = { url: url,
  								size: 2,
  					 namespace: "TF_#{ Rails.env }" }
  config.poll_interval = 15
end

Sidekiq.configure_client do |config|
  config.redis = { url: url,
  								size: 1,
  					 namespace: "TF_#{ Rails.env }" }
end