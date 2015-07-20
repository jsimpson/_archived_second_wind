class AddGeoRouteProcessedToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :geo_route_processed, :boolean, null: false, default: false
  end
end
