class GeoRouteWorker
  include Sidekiq::Worker

  def perform(id)
    activity = Activity.find(id)

    unless activity.blank?
      format = get_format(File.extname(activity.geo_route.path))
      file = File.open(activity.geo_route.path)
      route = Broutes.from_file(file, format)
      binding.pry

      update_activity(activity, route)
      activity.save

      create_geo_points(activity.id, route) unless activity.geo_points.any?
      create_laps(activity.id, route) unless activity.laps.any?
    end
  end

  private

  def get_format(ext)
    case ext
    when '.gpx'
      :gpx_track
    when '.tcx'
      :tcx
    end
  end

  def update_activity(activity, route)
    activity.geo_route_processed = true
    activity.started_at = route.started_at
    activity.ended_at = route.ended_at
    activity.total_elevation_gain = route.total_ascent
    activity.total_elevation_loss = route.total_descent
    activity.total_time = route.total_time
    activity.total_distance = route.total_distance
    activity.max_speed = route.maximum_speed
    activity.min_speed = route.minimum_speed
    activity.average_speed = route.average_speed
    activity.max_elevation = route.maximum_elevation
    activity.min_elevation = route.minimum_elevation
    activity.max_heart_rate = route.maximum_heart_rate
    activity.min_heart_rate = route.minimum_heart_rate
    activity.average_heart_rate = route.average_heart_rate
    activity.total_calories = route.total_calories
    activity.sport = route.type

    first_point = route.points.reject { |point| point.lat.blank? || point.lon.blank? }.first if route.points.any?
    if first_point.present?
      activity.latitude = first_point.lat
      activity.longitude = first_point.lon

      geo = Geocoder.search("#{activity.latitude}, #{activity.longitude}")
      unless geo.blank?
        activity.full_address = geo.first.address
        activity.city = geo.first.city
        activity.state = geo.first.state
        activity.country = geo.first.country
        activity.country_code = geo.first.country_code
      end
    end

    as = Activity.where(sport: activity.sport).average(:average_speed)
    unless as.blank? || as == 0.0
      if activity.average_speed > as
        activity.speed_trend = 1
      elsif activity.average_speed < as
        activity.speed_trend = -1
      end
    end
  end

  def create_laps(id, route)
    route.laps.each do |lap|
      route_lap = Lap.new(
        activity_id: id,
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

  def create_geo_points(id, route)
    route.points.each do |point|
      geo_point = GeoPoint.new(
        activity_id: id,
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
