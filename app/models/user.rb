class User < ApplicationRecord
  PROVIDER = %w(developer github).freeze

  def self.find_or_create_from_auth_hash(auth_hash)
    user_id, provider = auth_hash.values_at :uid, :provider

    find_or_initialize_by(user_id: user_id, provider: provider).tap do |user|
      name, email = auth_hash.info.values_at :name, :email
      user.email = email
      user.name = name
      user.save!
    end
  end

  validates :user_id, :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :provider, inclusion: { in: PROVIDER }
end
