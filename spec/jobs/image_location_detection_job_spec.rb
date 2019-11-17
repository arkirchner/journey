require "rails_helper"

RSpec.describe ImageLocationDetectionJob, type: :job do
  describe ".perform" do
    it "processes the image" do
      image = double("UnprocessedImage", id: 1)
      allow(image).to receive(:process)
      allow(UnprocessedImage).to receive(:find).with(1).and_return(image)

      described_class.new.perform(1)

      expect(image).to have_received(:process)
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
