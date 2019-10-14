source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "~> 2.6.3"

gem "dotenv-rails", require: "dotenv/rails-now"

gem "autoprefixer-rails"
gem "bootsnap", require: false
gem "daemons"
gem "delayed_job_active_record"
gem "honeybadger"
gem "image_processing"
gem "inline_svg"
gem "mini_magick"
gem "oj"
gem "omniauth"
gem "omniauth-github"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 6.0.0"
gem "recipient_interceptor"
gem "sassc-rails"
gem "simple_form"
gem "skylight"
gem "spring-commands-rspec", group: :development
gem "sprockets", ">= 3.0.0"
gem "title"
gem "turbolinks"
gem "webpacker"

group :development do
  gem "listen"
  gem "rack-mini-profiler", require: false
  gem "spring"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "suspenders"
end

group :test do
  gem "capybara-selenium"
  gem "chromedriver-helper"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

gem "rack-timeout", group: :production
