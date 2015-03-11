namespace :geo_route do
  GEO_ROUTE_FILES = Rake::FileList.new("lib/assets/geo_routes/**/*.tcx")

  desc "Import GeoRoute files"
  task import: :environment do
    GEO_ROUTE_FILES.each do |f|
      run = Run.new(geo_route: File.new(f))
      run.save

      run.destroy if Run.all.where(started_at: run.started_at).count > 1
    end
  end

  desc "Import a single GeoRoute file"
  task :import_single, [:f] => :environment do |task, args|
    run = Run.new(geo_route: File.new(args[:f]))
    run.save

    run.destroy if Run.all.where(started_at: run.started_at).count > 1
  end
end
