require 'redis'

redis_host = ENV['REDIS_HOST']
redis_port = ENV['REDIS_PORT']
redis_url = "redis://#{redis_host}:#{redis_port}/0"

$redis = Redis.new(url: redis_url)
