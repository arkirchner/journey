class ImageLocationDetectionJob < ApplicationJob
  queue_as :urgent

  def perform(id)
    @unprocessed_image = UnprocessedImage.find(id)
    update_lat_lng
  end

  private

  attr_reader :unprocessed_image

  def update_lat_lng
    unprocessed_image.update!(lat_lng.merge(position_processed: true))
  end

  def lat_lng
    unprocessed_image.image.open do |file|
      data = Exif::Data.new(file)

      {
        lat: rational_coordinate_to_decimal(data.gps_latitude),
        lng: rational_coordinate_to_decimal(data.gps_longitude),
      }
    end
  rescue Exif::NotReadable
    IpLocation.by_ip(unprocessed_image.uploader_ip)
  end

  def rational_coordinate_to_decimal(coordinate)
    degrees, minutes, seconds = coordinate
    (degrees + minutes / 60 + seconds / 3_600).to_f
  end
end
