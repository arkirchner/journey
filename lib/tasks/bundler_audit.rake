if Rails.env.development? || Rails.env.test?
  require "bundler/audit/cli"

  namespace :bundle do
    desc "Updates the ruby-advisory-db then runs bundle-audit"
    task :audit do
      system("bundle exec bundle-audit check --update --ignore CVE-2015-9284")
    end
  end
end
