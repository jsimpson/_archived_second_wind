# Second Wind

Second Wind is a self-hosted, anti-social running and cycling logbook.

:running: This app aims to replicate some of the functionality of Garmin Connect as well as provide additional features.

## Features

+ [Chartkick](https://github.com/ankane/chartkick) integration for plotting lifetime mileage by month (with [Groupdate](https://github.com/ankane/groupdate)) as well as the individual activities heart rate, elevation, and speed profiles.
+ Google Maps integration with the [Google-Maps-for-Rails](https://github.com/apneadiving/Google-Maps-for-Rails) gem for individual activity route map overlays.
+ Importing your GeoRoute files.

### GeoRoutes

This app uses the excellent [Broutes](https://github.com/adambird/broutes) Ruby gem for processing GeoRoute files. It supports the GPS Exchange File Format (.gpx) and the Garmin Training Center File Format (.tcx).

## Installation

Clone this repository

```git
git clone http://github.com/jsimpson/second_wind.git
```

I use [rbenv](https://github.com/sstephenson/rbenv) and [rbenv-gemset](https://github.com/jf/rbenv-gemset). You'll need to get the required gems installed...

Prepare the database

```sh
bundle exec rake db:create
bundle exec rake db:migrate
```

Download your GeoRoute files from Garmin (or where ever they end up). I use the [Disconnect](https://gist.github.com/jsimpson/174beffe4e32222cf4da) script to download my GeoRoute files to `lib/assets/geo_routes`

Execute the `geo_route:import` rake task to import the GeoRoutes as activities.

```sh
bundle exec rake geo_route:import
```

This will take some time, potentially a very considerable amount of time if you have many GeoRoutes to import.
