FactoryBot.define do
  factory :user do
    sequence(:user_id) { |n| sprintf("%010d", n) }
    sequence(:name) { |n| "Github User #{n}" }
    provider { "github" }
    sequence(:email) { |n| "user_#{n}@example.com" }
  end
end
