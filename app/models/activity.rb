class Activity < ActiveRecord::Base
  has_many :geo_points
  has_many :laps

  has_attached_file :geo_route, url: '/public/geo_routes/:id/:filename', path: ':rails_root:url'
  validates_attachment_content_type :geo_route, content_type: ['application/xml', 'application/octet-stream']
  validates_attachment_file_name :geo_route, matches: [/gpx\Z/, /tcx\Z/]

  after_save :update_route, if: ->(obj) { obj.geo_route_processed == false && obj.geo_route.present? }
  scope :started_at, -> { order('started_at DESC') }

  class << self
    def group_mileage_by_month
      unscoped
        .group_by_month(:started_at, format: '%B %Y')
        .sum(:total_distance)
        .map { |m| { m[0] => (m[1] * 0.000621371).round(2) }.flatten }
    end

    def find_by_period(period = Time.now.all_year)
      where(started_at: period)
    end

    def sum_distance
      sum(:total_distance) * 0.000621371
    end

    def sum_elevation_gain
      sum(:total_elevation_gain) * 3.28084
    end

    def sum_time
      time = sum(:total_time)
      seconds = time % 60
      minutes = (time / 60) % 60
      hours = time / 3600
      "#{hours} hrs, #{minutes} mins, #{seconds} secs"
    end

    def average_heart_rate
      average(:average_heart_rate)
    end

    def sum_calories
      sum(:total_calories)
    end
  end

  private

  def update_route
    UpdateGeoRouteService.new.execute(id)
  end
end
