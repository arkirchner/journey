FactoryBot.define do
  factory :user do
    sequence(:user_id) { |n| sprintf("%010d", n) }
    sequence(:name) { |n| "Github User #{n}" }
    provider { "github" }
    sequence(:email) { |n| "user_#{n}@example.com" }
  end

  factory :unprocessed_image do
    user
    jpg

    lat { rand(-90.00000..90.0000) }
    lng { rand(-180.00000..180.0000) }
    uploader_ip { Faker::Internet.ip_v4_address }

    trait :jpg do
      image do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy.jpg"),
        )
      end
    end

    trait :png do
      image do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy.png"),
        )
      end
    end
  end
end
