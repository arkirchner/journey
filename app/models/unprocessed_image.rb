class UnprocessedImage < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :with_user, ->(user) { where(user: user) }

  def processed?
    position_processed?
  end

  def process_later
    ImageLocationDetectionJob.perform_later(id)
  end

  def process
    update!(lat_lng.merge(position_processed: true))
  end

  private

  def lat_lng
    image.open do |file|
      data = Exif::Data.new(file)

      if data.gps_latitude && data.gps_longitude
        {
          lat: rational_coordinate_to_decimal(data.gps_latitude),
          lng: rational_coordinate_to_decimal(data.gps_longitude),
        }
      else
        IpLocation.by_ip(uploader_ip)
      end
    end
  rescue Exif::NotReadable
    IpLocation.by_ip(uploader_ip)
  end

  def rational_coordinate_to_decimal(coordinate)
    degrees, minutes, seconds = coordinate
    (degrees + minutes / 60 + seconds / 3_600).to_f
  end
end
