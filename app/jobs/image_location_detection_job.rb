class ImageLocationDetectionJob < ApplicationJob
  queue_as :urgent

  def perform(id)
    UnprocessedImage.find(id).process
  end
end
