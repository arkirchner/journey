require "rails_helper"

describe "My Page", js: true do
  before do
    sign_up_with_github
  end

  it "uploads images dropped on drop zone" do
    upload_file

    # the unprocessed-image is created and displayed
    within "#unprocessed-images" do
      expect(page).to have_css("img[src*='dummy.jpg']")
    end
  end

  it "can save the uploaded file to the journey" do
    upload_file

    click_on "Save to journey"

    expect(page).to have_text("Hoge Moge")
  end

  def upload_file
    file = File.path(Rails.root.join("spec", "fixtures", "dummy.jpg"))
    drop_file("#drop-zone", file)

    # image is possessed
    within "#drop-zone" do
      expect(page).to have_css("img", visible: false)
    end
  end
end
