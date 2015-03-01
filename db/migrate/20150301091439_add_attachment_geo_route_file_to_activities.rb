class AddAttachmentGeoRouteFileToActivities < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.attachment :geo_route_file
    end
  end

  def self.down
    remove_attachment :activities, :geo_route_file
  end
end
