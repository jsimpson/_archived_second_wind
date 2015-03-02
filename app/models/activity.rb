class Activity < ActiveRecord::Base
  has_attached_file :geo_route_file, path: ':rails_root/public/geo_route_files/:id/:filename'
  validates_attachment_content_type :geo_route_file, content_type: ['application/octet-stream', 'application/gpx+xml', 'application/vnd.garmin.tcx+xml', 'application/vnd.ant.fit', 'application/xml']

  after_save :update_route

  scope :runs, -> { where(type: 'Running') }
  scope :rides, -> { where(type: 'Cycling') }

  def self.types
    %w(Running Cycling)
  end

  def update_route
    if !geo_route_file.nil?
      format = get_format
      file = File.open(geo_route_file.path)
      route = Broutes.from_file(file, format)

      self.update_column(:total_elevation_gain, route.total_ascent)
      self.update_column(:total_elevation_loss, route.total_descent)
      self.update_column(:total_time, route.total_time)
      self.update_column(:total_distance, route.total_distance)
      self.update_column(:average_speed, route.average_speed.nil)
      self.update_column(:average_pace, route.average_pace)
      self.update_column(:max_elevation, route.max_elevation)
      self.update_column(:min_elevation, route.min_elevation)
      self.update_column(:max_heart_rate, route.max_heart_rate)
      self.update_column(:min_heart_rate, route.min_heart_rate)
      self.update_column(:average_heart_rate, route.average_heart_rate)
      self.update_column(:total_calories, route.total_calories)
    end
  end

  private

    def get_format
      case File.extname(geo_route_file.path)
      when '.gpx'
        :gpx_track
      when '.tcx'
        :tcx
      end
    end
end
