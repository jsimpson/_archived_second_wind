class Activity < ActiveRecord::Base
  has_attached_file :geo_route_file, path: ":rails_root/public/geo_route_files/:id/:filename"
  validates_attachment_content_type :geo_route_file, content_type: ["application/gpx+xml", "application/vnd.garmin.tcx+xml", "application/vnd.ant.fit"]

  scope :runs, -> { where(type: 'Running') }
  scope :rides, -> { where(type: 'Cycling') }

  def self.types
    %w(Running Cycling)
  end
end
