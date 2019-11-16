require "rails_helper"

RSpec.describe ImageLocationDetectionJob, type: :job do
  describe ".perform" do
    around do |test|
      UnprocessedImage.skip_callback :create, :after, :process
      test.run
      UnprocessedImage.set_callback :create, :after, :process
    end

    it "updates the position processed flag" do
      image = create :unprocessed_image
      described_class.new.perform(image.id)
      image.reload

      expect(image).to be_position_processed
    end

    context "with images containing exif information" do
      it "extracts the position from jpg file" do
        image = create :unprocessed_image, :jpg
        described_class.new.perform(image.id)
        image.reload

        expect([image.lat, image.lng]).to eq [35.6724205, 139.700531]
      end

      it "extracts from png file" do
        image = create :unprocessed_image, :png
        described_class.new.perform(image.id)
        image.reload

        pending "exif info for png is not supported at the moment..."
        expect([image.lat, image.lng]).to match [35.6724205, 139.700531]
      end
    end

    context "when images contain no exif information" do
      stub_coordinates = [10.123, 40.123]
      no_exif_jpg =
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy_no_exif.jpg"),
        )
      no_exif_png =
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec", "fixtures", "dummy_no_exif.png"),
        )

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

      it "falles back to ip location detection for jpg files without exif" do
        image = create :unprocessed_image, image: no_exif_jpg
        described_class.new.perform(image.id)
        image.reload

        expect([image.lat, image.lng]).to eq stub_coordinates
      end

      it "falles back to ip location detection for png files without exif" do
        image = create :unprocessed_image, image: no_exif_png
        described_class.new.perform(image.id)
        image.reload

        expect([image.lat, image.lng]).to eq stub_coordinates
      end
    end
  end

  describe ".perform_later" do
    before { described_class.perform_later(1) }

    it "adds the job to the queue :urgent" do
      expect(enqueued_jobs.last).to match(
        job: described_class, args: [1], queue: "urgent",
      )
    end
  end
end
