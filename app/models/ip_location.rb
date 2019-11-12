class IpLocation < ApplicationRecord
  before_create :set_lat_lng

  def self.by_ip(ip)
    find_or_create_by(ip: ip).to_lat_lng
  end

  def to_lat_lng
    set_lat_lng && save! if cache_to_old?
    [lat, lng]
  end

  private

  def cache_to_old?
    updated_at < 1.day.ago
  end

  def set_lat_lng
    data = Geocoder.search(ip.to_s).first

    if data.blank?
      self.lat = 0.0
      self.lng = 0.0
      return
    end

    self.lat, self.lng = data.coordinates
  end
end
