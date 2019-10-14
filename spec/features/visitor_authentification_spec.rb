require "rails_helper"

describe "Visitor authentification", js: true do
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
end
