class Activity < ActiveRecord::Base
  has_many :geo_points
  has_many :laps

  has_attached_file :geo_route,
    url: '/public/geo_routes/:id/:filename', path: ':rails_root:url'
  validates_attachment_content_type :geo_route,
    content_type: ['application/xml', 'application/octet-stream']
  validates_attachment_file_name :geo_route, matches: [/gpx\Z/, /tcx\Z/]

  reverse_geocoded_by :latitude, :longitude do |obj, result|
    if geo = result.first
      obj.full_address = geo.address
      obj.city = geo.city
      obj.state = geo.state
      obj.country = geo.country
      obj.country_code = geo.country_code
      obj.save
    end
  end

  after_save :update_route, if: ->(obj) { obj.geo_route_processed == false && obj.geo_route.present? }
  after_save :reverse_geocode, if: ->(obj) { obj.full_address.blank? }
  default_scope -> { order('started_at DESC') }

  def self.group_mileage_by_month
    unscoped
      .group_by_month(:started_at, format: '%B %Y')
      .sum(:total_distance)
      .map { |m| { m[0] => (m[1] * 0.000621371).round(2) }.flatten }
  end

  def self.find_by_period(period = Time.now.all_year)
    where(started_at: period)
  end

  def self.sum_distance
    sum(:total_distance) * 0.000621371
  end

  def self.sum_elevation_gain
    sum(:total_elevation_gain) * 3.28084
  end

  def self.sum_time
    time = sum(:total_time)
    seconds = time % 60
    minutes = (time / 60) % 60
    hours = time / 3600
    "#{hours} hrs, #{minutes} mins, #{seconds} secs"
  end

  def self.average_heart_rate
    average(:average_heart_rate)
  end

  def self.sum_calories
    sum(:total_calories)
  end

  def update_trends
    as = Activity.where(sport: sport).average(:average_speed)

    unless as.blank? || as == 0.0
      if average_speed > as
        update_column(:speed_trend, 1)
      elsif average_speed < as
        update_column(:speed_trend, -1)
      end
    end
  end

  private

  def update_route
    format = get_format
    file = File.open(geo_route.path)
    route = Broutes.from_file(file, format)

    update_activity_geo_points(route) unless geo_points.any?
    update_activity_laps(route) unless laps.any?
    update_activity_summary(route)
    update_trends
  end

  def get_format
    case File.extname(geo_route.path)
    when '.gpx'
      :gpx_track
    when '.tcx'
      :tcx
    end
  end

  def update_activity_summary(route)
    update_columns(
      started_at: route.started_at,
      ended_at: route.ended_at,
      total_elevation_gain: route.total_ascent,
      total_elevation_loss: route.total_descent,
      total_time: route.total_time,
      total_distance: route.total_distance,
      max_speed: route.maximum_speed,
      min_speed: route.minimum_speed,
      average_speed: route.average_speed,
      max_elevation: route.maximum_elevation,
      min_elevation: route.minimum_elevation,
      max_heart_rate: route.maximum_heart_rate,
      min_heart_rate: route.minimum_heart_rate,
      average_heart_rate: route.average_heart_rate,
      total_calories: route.total_calories,
      sport: route.type,
      geo_route_processed: true
    )

    first_point = route.points.reject { |point| point.lat.blank? || point.lon.blank? }.first if route.points.any?
    update_columns(latitude: first_point.lat, longitude: first_point.lon) if first_point.present?
  end

  def update_activity_laps(route)
    route.laps.each do |lap|
      route_lap = Lap.new(
        activity: self,
        start_time: lap.start_time,
        total_time: lap.total_time,
        distance: lap.distance,
        calories: lap.calories,
        average_speed: lap.average_speed,
        maximum_speed: lap.maximum_speed,
        average_heart_rate: lap.average_heart_rate,
        maximum_heart_rate: lap.maximum_heart_rate
      )

      route_lap.save
    end
  end

  def update_activity_geo_points(route)
    route.points.each do |point|
      geo_point = GeoPoint.new(
        activity: self,
        cadence: point.cadence,
        distance: point.distance,
        elevation: point.elevation,
        heart_rate: point.heart_rate,
        lat: point.lat,
        lng: point.lon,
        power: point.power,
        speed: point.speed,
        time: point.time
      )

      geo_point.save
    end
  end
end
