require 'sidekiq/api'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] || "redis://localhost:6379/" }

  config.server_middleware do |chain|
    chain.add(Sidekiq::Status::ServerMiddleware, expiration: 30.minutes)
  end

  config.client_middleware do |chain|
    chain.add(Sidekiq::Status::ClientMiddleware, expiration: 30.minutes)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] || "redis://localhost:6379/" }

  config.client_middleware do |chain|
    chain.add(Sidekiq::Status::ClientMiddleware, expiration: 30.minutes)
  end
end
