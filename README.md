# Second Wind

Second Wind is a self-hosted, anti-social activity (cycling, hiking, and running) logbook.

:running: This app aims to replicate some of the core functionality of Garmin Connect, as well as provide some additional features and, most importantly to me, a way to keep your activities (data) yourself.

## Features

+ Lifetime mileage charting (by month) (thanks to [Chartkick](https://github.com/ankane/chartkick) with [Groupdate](https://github.com/ankane/groupdate)).
+ Individual activity heart rate, elevation, and speed profile charting.
+ Google Maps integration with the [Google-Maps-for-Rails](https://github.com/apneadiving/Google-Maps-for-Rails) gem for individual activity route map overlays.
+ Importing GeoRoute files in bulk or individually.
+ Display data in Imperial or Metric units

### Planned

+ Importing via the app, both bulk or individually.
+ GeoRoute exporting, again both bulk or individually.

### GeoRoutes

This app uses the very excellent [Broutes](https://github.com/adambird/broutes) Ruby gem for processing GeoRoute files. Second Wind currently only supports the GPS Exchange File Format (.gpx) and the Garmin Training Center File Format (.tcx).

## Installation

Clone this repository

```git
git clone http://github.com/jsimpson/second_wind.git
```

Get the required gems in place..

```sh
bundle install
```

Prepare the database

```sh
bundle exec rake db:create
bundle exec rake db:migrate
```

Set up the application settings so that it displays data in your prefered units of measurement.

If you're after Imperial units

```sh
bundle exec rake app_settings:imperial
```

If you're after Metric units

```sh
bundle exec rake app_settings:metric
```

### Import your GeoRoute files

You will need to download your GeoRoute files from Garmin (or where ever they end up). I use the [Disconnect](https://gist.github.com/jsimpson/174beffe4e32222cf4da) script to download (scrape) my GeoRoute files from Garmin Connect. If you use a different GPS vendor, you'll need to obtain your GeoRoute files another way.

Another option available is to use [Tapirik](https://tapiriik.com/) to synchronize activites from Garmin Connect to a folder on DropBox. From DropBox, you can download your activity files and import them.

Importing is currently only supported via Rake tasks, and **only the TCX GeoRoute file format** is currently supported.

#### Bulk importing GeoRoutes

Bulk importing currently requires the GeoRoute files to be in `lib/assets/geo_routes`.
Execute the `geo_route:import` rake task to bulk import the GeoRoute files as activities.

```sh
bundle exec rake geo_route:import
```

Please note: This may take some time, potentially a _very_ considerable amount of time if you have many GeoRoutes to import.

#### Single GeoRoute importing

Execute the `geo_route:import_single` rake task to import a single GeoRoute file as an activity. Pass the file location as an argument to the rake task.

```sh
bundle exec rake geo_route:import_single[path/to/geo_route.tcx]
```

Note that if you're using `zsh` you will need to escape the []:

```sh
bundle exec rake geo_route:import_single\[path/to/geo_route.tcx\]
```

## Notes for hosting on external servers

If you're planning to host this app on an external server you should remember to configure the applications time zone in `config/application.rb`

```ruby
config.time_zone = 'Pacific Time (US & Canada)'
```

You'll also need to get redis installed and configure the Sidekiq initializer to use the correct redis port. You can find more about that [here](https://github.com/mperham/sidekiq/wiki/Using-Redis).

Also, for what it's worth, I've had great success with [Mina](https://github.com/mina-deploy/mina) for automatically deploying this app to my hosting provider.

