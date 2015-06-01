namespace :geo_route do
  GEO_ROUTE_FILES = Rake::FileList.new("lib/assets/geo_routes/**/*.tcx")

  desc "Import GeoRoute files"
  task import: :environment do
    GEO_ROUTE_FILES.each do |f|
      activity = Activity.new(geo_route: File.new(f))
      activity.save

      activity.destroy if Activity.where(started_at: activity.started_at).count > 1
    end
  end

  desc "Import a single GeoRoute file"
  task :import_single, [:f] => :environment do |task, args|
    activity = Activity.new(geo_route: File.new(args[:f]))
    activity.save

    activity.destroy if Activity.where(started_at: activity.started_at).count > 1
  end
end
