FactoryGirl.define do
  factory :geo_point do
    cadence 1
    distance '9.99'
    elevation '9.99'
    heart_rate 1
    lat '9.99'
    lng '9.99'
    power '9.99'
    speed '9.99'
    time '2015-03-08 12:19:17'
  end

  factory :activity do
    factory :activity_with_summary do
      started_at { DateTime.new(2014, 07, 27, 6, 33, 46, '-7').to_time }
      ended_at { DateTime.new(2014, 07, 27, 9, 01, 00, '-7').to_time }
      total_elevation_gain { 526.79 }
      total_elevation_loss { 449.79 }
      total_time { 8_834 }
      total_distance { 21_446 }
      average_speed { 2.40 }
      max_speed { 4.19 }
      min_speed { 0.31 }
      max_elevation { 94.8 }
      min_elevation  { -11.0 }
      max_heart_rate { 173 }
      min_heart_rate { 111 }
      average_heart_rate { 154 }
    end

    factory :run_with_geo_route do
      geo_route { Rack::Test::UploadedFile.new('spec/fixtures/geo_route.tcx', 'application/xml') }
    end
  end
end
