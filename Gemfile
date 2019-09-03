source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "~> 2.6.3"

gem "autoprefixer-rails"

gem "bootsnap", require: false
gem "bourbon", ">= 5.0.1"
gem "honeybadger"
gem "high_voltage"
gem "neat", ">= 3.0.1"
gem "oj"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 6.0.0"
gem "recipient_interceptor"
gem "sassc-rails"
gem "skylight"
gem "sprockets", ">= 3.0.0"
gem "spring-commands-rspec", group: :development
gem "title"
gem "tzinfo-data", platforms: [:mingw, :x64_mingw, :mswin, :jruby]
gem "webpacker"
gem "simple_form"
gem "delayed_job_active_record"
gem "inline_svg"

group :development do
  gem "listen"
  gem "rack-mini-profiler", require: false
  gem "spring"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "dotenv-rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "suspenders"
  gem "bullet"
  gem "factory_bot_rails"
end

group :test do
  gem "formulaic"
  gem "launchy"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
  gem "shoulda-matchers"
  gem "capybara-selenium"
  gem "chromedriver-helper"
end

gem "rack-timeout", group: :production
