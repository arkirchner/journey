require "rails_helper"

RSpec.describe UnprocessedImage, type: :model do
  it { is_expected.to belong_to :user }

  it "starts processing the image when saved" do
    image = build :unprocessed_image

    expect { image.save! }.to have_enqueued_job(ImageLocationDetectionJob).with(
      image.id,
    )
  end
end
