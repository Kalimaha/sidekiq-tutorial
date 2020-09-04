Sidekiq.configure_server do |config|
  config.redis = { url: "rediss://default:bwex4x57d720m2sq@vinomofo-redis-test-vinomofo-81f7.aivencloud.com:13193" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "rediss://default:bwex4x57d720m2sq@vinomofo-redis-test-vinomofo-81f7.aivencloud.com:13193" }
end
