class GeoPoint < ActiveRecord::Base
  belongs_to :activity

  default_scope -> { order('time ASC') }

  def self.lat_lng
    pluck(:lat, :lng)
      .reject { |point| point.any?(&:blank?) }
      .map { |point| { lat: point[0].to_f, lng: point[1].to_f } }
  end

  def self.heart_rate
    pluck(:time, :heart_rate)
      .reject { |point| point.any?(&:blank?) }
      .map { |point| { point[0] => point[1] }.flatten }
      .uniq
  end

  def self.heart_rate_intensity
    points = pluck(:heart_rate).reject(&:blank?)
    count = points.count

    points
      .group_by { |x| x / 10 }
      .sort
      .map { |k, vs| { ((10 * k)..(10 * k + 10)) => ((vs.count.to_f / count.to_f) * 100.0).round(2) }.flatten }
  end

  def self.elevation
    pluck(:time, :elevation)
      .reject { |point| point.any?(&:blank?) }
      .map { |point| { point[0] => (point[1] * 3.28084).round(2) }.flatten }
      .uniq
  end

  def self.speed
    pluck(:time, :speed)
      .reject { |point| point.any?(&:blank?) }
      .map { |point| { point[0] => (point[1] * 2.23694).round(2) }.flatten }
      .uniq
  end
end
