module AuthHelper
  def sign_up_with_github
    visit "/"
    click_link "Github"
  end

  def sign_out
    click_on "Github User"
    click_on "Sign Out!"
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :feature
  config.before(:each, type: :feature, js: true) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :github,
      uid: "12345", info: { name: "Github User", email: "test@hoge.com" },
    )
  end

  config.after(:each, type: :feature, js: true) do
    OmniAuth.config.mock_auth[:twitter] = nil
  end
end
