Sidekiq.configure_server do |config|
  config.redis = { url: "redis://redistogo:ea085b508bdf053c861d846d34032956@scat.redistogo.com:9588" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://redistogo:ea085b508bdf053c861d846d34032956@scat.redistogo.com:9588" }
end
