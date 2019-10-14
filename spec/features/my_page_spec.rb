require "rails_helper"

describe "My Page", js: true do
  before do
    sign_up_with_github
    expect(page).to have_current_path(my_page_path)
  end

  it "uploads images dropped on drop zone" do
    file = File.path(Rails.root.join("spec", "fixtures", "dummy.jpg"))
    drop_file("#drop-zone", file)

    # image is possessed
    within "#drop-zone" do
      expect(page).to have_css("img", visible: false)
    end

    # the unprocessed-images is created and displayed
    within "#unprocessed-images" do
      expect(page).to have_css("img[src*='dummy.jpg']")
    end
  end
end
