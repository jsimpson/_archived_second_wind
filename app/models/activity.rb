class Activity < ActiveRecord::Base
  has_many :geo_points

  has_attached_file :geo_route, url: '/public/geo_routes/:id/:filename', path: ':rails_root:url'
  validates_attachment_content_type :geo_route, content_type: ['application/xml', 'application/octet-stream']
  validates_attachment_file_name :geo_route, matches: [/gpx\Z/, /tcx\Z/]

  after_save :update_route

  default_scope -> { order('started_at DESC') }
  scope :runs, -> { where(type: 'Run') }
  scope :rides, -> { where(type: 'Ride') }

  def self.types
    %w(Run Ride)
  end

  def elapsed_time
    seconds = self.total_time % 60
    minutes = (self.total_time / 60) % 60
    hours = self.total_time/3600
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end

  def get_total_distance
    total_distance * 0.000621371
  end

  def get_average_speed
    average_speed * 2.23694
  end

  def update_route
    if !geo_route.nil?
      format = get_format
      file = File.open(geo_route.path)
      route = Broutes.from_file(file, format)

      update_activity_summary(route)
      update_activity_geo_points(route)
    end
  end

  def get_geo_points_lat_lng
    return geo_points.to_enum.reject { |p| p.lat == nil || p.lng == nil }.map { |p| { lat: p.lat.to_f, lng: p.lng.to_f }} if geo_points.any?
  end

  def get_geo_points_heart_rate
    return geo_points.where(activity_id: self.id).reject { |p| p.heart_rate == nil }.map { |p| { p.time => p.heart_rate }.flatten }.uniq if geo_points.any?
  end

  def get_geo_points_elevation
    return geo_points.where(activity_id: self.id).reject { |p| p.elevation == nil }.map { |p| { p.time => p.elevation.round(2) }.flatten }.uniq if geo_points.any?
  end

  def get_geo_points_speed
    return geo_points.where(activity_id: self.id).reject { |p| p.speed == nil }.map { |p| { p.time => p.speed.round(2) }.flatten }.uniq if geo_points.any?
  end

  private

    def get_format
      case File.extname(geo_route.path)
      when '.gpx'
        :gpx_track
      when '.tcx'
        :tcx
      end
    end

    def update_activity_summary(route)
      self.update_column(:started_at, route.started_at)
      self.update_column(:ended_at, route.ended_at)
      self.update_column(:total_elevation_gain, route.total_ascent)
      self.update_column(:total_elevation_loss, route.total_descent)
      self.update_column(:total_time, route.total_time)
      self.update_column(:total_distance, route.total_distance)
      self.update_column(:average_speed, route.average_speed)
      self.update_column(:max_elevation, route.maximum_elevation)
      self.update_column(:min_elevation, route.minimum_elevation)
      self.update_column(:max_heart_rate, route.maximum_heart_rate)
      self.update_column(:min_heart_rate, route.minimum_heart_rate)
      self.update_column(:average_heart_rate, route.average_heart_rate)
    end

    def update_activity_geo_points(route)
      route.points.each do |p|
        geo_point = GeoPoint.new(
          activity: self,
          cadence: p.cadence,
          distance: p.distance,
          elevation: p.elevation,
          heart_rate: p.heart_rate,
          lat: p.lat,
          lng: p.lon,
          power: p.power,
          speed: p.speed,
          time: p.time
        )

        geo_point.save
      end
    end
end
