require "rails_helper"

describe "Visitor authentification", js: true do
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

  it "visitor can sign up with Github" do
    sign_up_with_github

    expect(page).to have_content("Github User")
    expect(page).to have_content("Explore your journey around the world.")
  end

  it "sign out and move to landing page" do
    sign_up_with_github
    sign_out

    expect(page).to have_content("Until next time Github User.")
    expect(page).to have_current_path(root_path)
  end

  def sign_up_with_github
    visit "/"
    click_link "Github"
  end

  def sign_out
    click_on "Github User"
    click_on "Sign Out!"
  end
end
