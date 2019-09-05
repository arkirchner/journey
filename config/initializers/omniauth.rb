Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  if ENV["GITHUB_KEY"] && ENV["GITHUB_SECRET"]
    provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"]
  end
end
