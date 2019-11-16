class UnprocessedImage < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :with_user, ->(user) { where(user: user) }

  def update_lat_lng_from_image
    image.open do |file|
      data = Exif::Data.new(file)

      update!(
        lat: rational_coordinate_to_decimal(data.gps_latitude),
        lng: rational_coordinate_to_decimal(data.gps_longitude),
      )
    end
  rescue Exif::NotReadable
    self.lat, self.lng = IpLocation.by_ip(uploader_ip)
    save!
  end

  private

  def rational_coordinate_to_decimal(coordinate)
    degrees, minutes, seconds = coordinate
    (degrees + minutes / 60 + seconds / 3600).to_f
  end
end
