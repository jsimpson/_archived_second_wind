# Second Wind

Second Wind is a self-hosted, anti-social activity (cycling, hiking, and running) logbook.

:running: This app aims to replicate some of the core functionality of Garmin Connect, as well as provide some additional features and, most importantly to me, a way to keep your activities (data) yourself.

Please note that I'm an American and this app is currently *hard-coded* to support Imperial units. There are plans to provide the ability to toggle Imperial units on (since GeoRoutes already store data in metric units) but it's not currently a priority (sorry, everyone else in the world).

## Features

+ Lifetime mileage charting (by month) (thanks to [Chartkick](https://github.com/ankane/chartkick) with [Groupdate](https://github.com/ankane/groupdate)).
+ Individual activity heart rate, elevation, and speed profile charting.
+ Google Maps integration with the [Google-Maps-for-Rails](https://github.com/apneadiving/Google-Maps-for-Rails) gem for individual activity route map overlays.
+ Importing GeoRoute files in bulk or individually.

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

Download your GeoRoute files from Garmin (or where ever they end up). I use the [Disconnect](https://gist.github.com/jsimpson/174beffe4e32222cf4da) script to download (scrape) my GeoRoute files from Garmin Connect. If you use a different GPS vendor, you'll need to obtain your GeoRoute files another way.

### Companion Rake tasks

Importing currently only supports TCX GeoRoute file formats.

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
