class IpLocation < ApplicationRecord
  FALLBACK_LAT = 0
  FALLBACL_LNG = 0

  before_create :set_lat_lng

  def self.by_ip(ip)
    find_or_create_by(ip: ip).to_lat_lng
  end

  def to_lat_lng
    set_lat_lng && save! if cache_to_old?
    { lat: lat, lng: lng }
  end

  private

  def cache_to_old?
    updated_at < 1.day.ago
  end

  def set_lat_lng
    lat, lng = Geocoder.search(ip.to_s).first&.coordinates

    assign_attributes(lat: lat || FALLBACK_LAT, lng: lng || FALLBACL_LNG)
  end
end
