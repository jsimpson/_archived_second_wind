class Activity < ActiveRecord::Base
  has_many :geo_points

  has_attached_file :geo_route,
    url: '/public/geo_routes/:id/:filename',
    path: ':rails_root:url'

  validates_attachment_content_type :geo_route,
    content_type: ['application/xml', 'application/octet-stream']

  validates_attachment_file_name :geo_route, matches: [/gpx\Z/, /tcx\Z/]

  after_create :update_route

  default_scope -> { order('started_at DESC') }

  def self.types
    %w(Run Ride)
  end

  def elapsed_time
    format('%02d:%02d:%02d',
      get_hours(total_time),
      get_minutes(total_time),
      get_seconds(total_time))
  end

  def get_total_distance
    total_distance * 0.000621371
  end

  def get_average_speed
    average_speed * 2.23694
  end

  def get_average_pace
    return '00:00' if average_speed == 0.0
    pace = (60 / (average_speed * 2.23694)).to_d
    seconds = (pace.frac * 60).floor
    format('%02d:%02d', pace.fix, seconds)
  end

  def get_max_speed
    max_speed * 2.23694
  end

  def get_max_pace
    return '00:00' if max_speed == 0.0
    pace = (60 / (max_speed * 2.23694)).to_d
    seconds = (pace.frac * 60).floor
    format('%02d:%02d', pace.fix, seconds)
  end

  def get_total_elevation_gain
    total_elevation_gain * 3.28084
  end

  def get_total_elevation_loss
    total_elevation_loss * 3.28084
  end

  def get_max_elevation
    max_elevation * 3.28084
  end

  def get_min_elevation
    min_elevation * 3.28084
  end

  def update_route
    unless geo_route.nil?
      format = get_format
      file = File.open(geo_route.path)
      route = Broutes.from_file(file, format)

      update_activity_summary(route)
      update_activity_geo_points(route)
    end
  end

  def get_geo_points_lat_lng
    return geo_points.to_enum.reject { |p| p.lat.nil? || p.lng.nil? }.map { |p| { lat: p.lat.to_f, lng: p.lng.to_f } } if geo_points.any?
  end

  def get_geo_points_heart_rate
    return geo_points.where(activity_id: id).reject { |p| p.heart_rate.nil? }.map { |p| { p.time => p.heart_rate }.flatten }.uniq if geo_points.any?
  end

  def get_geo_points_elevation
    return geo_points.where(activity_id: id).reject { |p| p.elevation.nil? }.map { |p| { p.time => (p.elevation * 3.28084).round(2) }.flatten }.uniq if geo_points.any?
  end

  def get_geo_points_speed
    return geo_points.where(activity_id: id).reject { |p| p.speed.nil? }.map { |p| { p.time => (p.speed * 2.23694).round(2) }.flatten }.uniq if geo_points.any?
  end

  # TODO: calculates non-timey numerical pace values, currently unused
  def get_geo_points_pace
    return geo_points.where(activity_id: id).reject { |p| p.speed.nil? }.map { |p| { p.time => (60 / (p.speed * 2.23694)).round(2) }.flatten }.uniq if geo_points.any?
  end

  def self.analytics_by_day_of_week
    unscoped.group_by_day_of_week(:started_at, format: '%A').count
  end

  def self.analytics_by_month_of_year
    unscoped.group_by_month_of_year(:started_at, format: '%B').count
  end

  def self.group_mileage_by_month
    unscoped.group_by_month(:started_at, format: '%B %Y').sum(:total_distance).map { |m| { m[0] => (m[1] * 0.000621371).round(2) }.flatten }
  end

  def self.get_activites_for_period_of(period = 1.year)
    where(started_at: Time.now - period..Time.now)
  end

  def self.sum_distance
    sum(:total_distance) * 0.000621371
  end

  def self.sum_elevation_gain
    sum(:total_elevation_gain) * 3.28084
  end

  def self.sum_time
    t = sum(:total_time)
    seconds = t % 60
    minutes = (t / 60) % 60
    hours = t / 3600
    "#{hours} hrs, #{minutes} mins, #{seconds} secs"
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
    update_column(:started_at, route.started_at)
    update_column(:ended_at, route.ended_at)
    update_column(:total_elevation_gain, route.total_ascent)
    update_column(:total_elevation_loss, route.total_descent)
    update_column(:total_time, route.total_time)
    update_column(:total_distance, route.total_distance)
    update_column(:max_speed, route.maximum_speed)
    update_column(:min_speed, route.minimum_speed)
    update_column(:average_speed, route.average_speed)
    update_column(:max_elevation, route.maximum_elevation)
    update_column(:min_elevation, route.minimum_elevation)
    update_column(:max_heart_rate, route.maximum_heart_rate)
    update_column(:min_heart_rate, route.minimum_heart_rate)
    update_column(:average_heart_rate, route.average_heart_rate)
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

  def get_seconds(time)
    time % 60
  end

  def get_minutes(time)
    (time / 60) % 60
  end

  def get_hours(time)
    time / 3600
  end
end
