require "rails_helper"

describe "Visitor signs up", js: true do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :github,
      uid: "12345", info: { name: "Github User", email: "test@hoge.com" },
    )
  end

  after do
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  it "succeeds with valid valid github account" do
    sign_up_github

    expect(page).to have_content("Github User")
  end

  def sign_up_github
    visit "/"
    click_link "Sign in with github"
  end
end
