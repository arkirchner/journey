require "rails_helper"

RSpec.describe IpLocation, type: :model do
  describe "#byIP" do
    before do
      Geocoder::Lookup::Test.add_stub(
        "124.155.111.72",
        [
          {
            "coordinates" => [35.6363, 139.6795],
            "address" => "Tokyo, Tokyo, JP",
            "state" => "Tokyo",
            "country" => "Japan",
            "country_code" => "JP",
          },
        ],
      )

      Geocoder::Lookup::Test.add_stub("1.2.3.4", [])
    end

    it "returns coordinates for an IP" do
      coordinates = described_class.by_ip("124.155.111.72")

      expect(coordinates).to match(lat: 35.6363, lng: 139.6795)
    end

    it "returns the default position for an IP with unknow location" do
      coordinates = described_class.by_ip("1.2.3.4")

      expect(coordinates).to match(lat: 0.0, lng: 0.0)
    end

    context "with position look up cache" do
      around { |test| Timecop.freeze { test.run } }

      it "dose not call the ip position look if a record is cached" do
        described_class.create(ip: "5.5.5.5")
        Timecop.travel(1.day.from_now - 1.second)

        allow(Geocoder).to receive(:search).and_return([])
        described_class.by_ip("5.5.5.5")

        expect(Geocoder).not_to have_received(:search)
      end

      it "calls the ip position look if the records cache is older then 24h" do
        described_class.create(ip: "5.5.5.5")
        Timecop.travel(1.day.from_now)

        allow(Geocoder).to receive(:search).and_return([])
        described_class.by_ip("5.5.5.5")

        expect(Geocoder).to have_received(:search)
      end
    end
  end
end
