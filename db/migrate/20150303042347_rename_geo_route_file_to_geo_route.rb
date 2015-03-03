class RenameGeoRouteFileToGeoRoute < ActiveRecord::Migration
  def self.up
    rename_column :activities, :geo_route_file_file_name, :geo_route_file_name
    rename_column :activities, :geo_route_file_content_type, :geo_route_content_type
    rename_column :activities, :geo_route_file_file_size, :geo_route_file_size
    rename_column :activities, :geo_route_file_updated_at, :geo_route_updated_at
  end

  def self.down
    remove_column :activities, :geo_route_file_name
    remove_column :activities, :geo_route_content_type
    remove_column :activities, :geo_route_file_size
    remove_column :activities, :geo_route_updated_at
  end
end
