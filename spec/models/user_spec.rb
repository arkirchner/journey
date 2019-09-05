require "rails_helper"

RSpec.describe User, type: :model do
  describe ".find_or_create_from_auth_hash" do
    let(:github) do
      OmniAuth::AuthHash.new(
        provider: "github",
        uid: "123456",
        info: { name: "Github User", email: "github_user@example.com" },
      )
    end

    it "create a valid user" do
      expect(find_or_create_from_auth_hash(github)).to be_valid
    end

    it "finds a already created user" do
      user = find_or_create_from_auth_hash(github)

      expect(find_or_create_from_auth_hash(github)).to eq user
    end

    def find_or_create_from_auth_hash(params)
      User.find_or_create_from_auth_hash(params)
    end
  end

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_inclusion_of(:provider).in_array User::PROVIDER }

  context "with email address patterns" do
    let(:user) { build(:user) }

    it "allows a valid email address" do
      expect(user).to be_valid
    end

    it "rejects no email address" do
      user.email = ""

      expect(user).to be_invalid
    end

    it "rejects invalid email address" do
      user.email = "@example.com"

      expect(user).to be_invalid
    end
  end
end
