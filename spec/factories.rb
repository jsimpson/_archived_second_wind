FactoryGirl.define do
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
      latitude { 34.4332600571215 }
      longitude { -119.860240537673 }
      city { 'Goleta' }
      state { 'California' }
      country_code { 'US' }
    end

    factory :run_with_geo_route do
      geo_route { Rack::Test::UploadedFile.new('spec/fixtures/geo_route.tcx', 'application/xml') }
    end
  end

  factory :lap do
    start_time { DateTime.new(2014, 07, 27, 6, 33, 46, '-7').to_time }
    total_time { 367 }
    distance { 1_112 }
    calories { 112 }
    average_speed { 2.40 }
    maximum_speed { 4.19 }
    average_heart_rate { 111 }
    maximum_heart_rate { 173 }
  end

  factory :geo_point do
  end
end
