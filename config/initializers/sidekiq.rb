require 'sidekiq'
require 'sidekiq-cron'

redis_host = ENV['REDIS_HOST']
redis_port = ENV['REDIS_PORT']
redis_url = "redis://#{redis_host}:#{redis_port}/0"

# Set Redis connection
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

# Load cron schedule
schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
