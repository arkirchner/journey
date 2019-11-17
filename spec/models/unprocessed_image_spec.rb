require "rails_helper"

RSpec.describe UnprocessedImage, type: :model do
  it { is_expected.to belong_to :user }

  describe ".process_later" do
    it "starts processing the image when saved" do
      image = create(:unprocessed_image)

      expect { image.process_later }.to have_enqueued_job(
        ImageLocationDetectionJob,
      )
        .with(image.id)
    end
  end

  describe ".process" do
    stub_coordinates = [10.123, 40.123]

    before do
      Geocoder::Lookup::Test.set_default_stub(
        [
          {
            "coordinates" => stub_coordinates,
            "address" => "New York, NY, USA",
            "state" => "New York",
            "state_code" => "NY",
            "country" => "United States",
            "country_code" => "US",
          },
        ],
      )
    end

    it "updates the position processed flag" do
      image = create :unprocessed_image
      image.process

      expect(image).to be_position_processed
    end

    context "with images containing exif information" do
      it "extracts the position from jpg file" do
        image = create :unprocessed_image, :jpg
        image.process

        expect([image.lat, image.lng]).to eq [35.6724205, 139.700531]
      end

      it "extracts from png file" do
        image = create :unprocessed_image, :png
        image.process

        pending "exif info for png is not supported at the moment..."
        expect([image.lat, image.lng]).to match [35.6724205, 139.700531]
      end

      exif_with_no_position_jpg =
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy_exif_no_position.jpg"),
        )

      exif_with_no_position_png =
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy_exif_no_position.png"),
        )

      it "falles back to ip location detection for jpg files without exif" do
        image = create :unprocessed_image, image: exif_with_no_position_jpg
        image.process

        expect([image.lat, image.lng]).to eq stub_coordinates
      end

      it "falles back to ip location detection for jpg files without exif" do
        image = create :unprocessed_image, image: exif_with_no_position_png
        image.process

        expect([image.lat, image.lng]).to eq stub_coordinates
      end
    end

    context "when images contain no exif information" do
      no_exif_jpg =
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy_no_exif.jpg"),
        )

      no_exif_png =
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy_no_exif.png"),
        )

      it "falles back to ip location detection for jpg files without exif" do
        image = create :unprocessed_image, image: no_exif_jpg
        image.process

        expect([image.lat, image.lng]).to eq stub_coordinates
      end

      it "falles back to ip location detection for png files without exif" do
        image = create :unprocessed_image, image: no_exif_png
        image.process

        expect([image.lat, image.lng]).to eq stub_coordinates
      end
    end
  end
end
