if Rails.env.production?
  ActionMailer::Base.asset_host = ::CatarseSettings.get_without_cache(:host)
  Rails.application.routes.default_url_options = {host: "juntos.com.vc"}
else
  Rails.application.routes.default_url_options = {host: 'localhost:3000'}
end
