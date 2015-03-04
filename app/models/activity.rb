class Activity < ActiveRecord::Base
  has_attached_file :geo_route, url: '/public/geo_routes/:id/:filename', path: ':rails_root:url'
  validates_attachment_content_type :geo_route, content_type: ['application/xml', 'application/octet-stream']
  validates_attachment_file_name :geo_route, matches: [/gpx\Z/, /tcx\Z/]

  after_save :update_route

  scope :runs, -> { where(type: 'Run') }
  scope :rides, -> { where(type: 'Ride') }

  def self.types
    %w(Run Ride)
  end

  def elapsed_time
    seconds = self.total_time % 60
    minutes = (self.total_time / 60) % 60
    hours = self.total_time/3600
    if hours > 0
      "#{hours.to_s} hrs, #{minutes.to_s} mins, #{seconds.to_s} secs"
    else
      "#{minutes.to_s} mins, #{seconds.to_s} secs"
    end
  end

  def update_route
    if !geo_route.nil?
      format = get_format
      file = File.open(geo_route.path)
      route = Broutes.from_file(file, format)

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
end
