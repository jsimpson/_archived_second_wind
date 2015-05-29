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
    factory :run do
      type 'Running'
      factory :run_with_geo_route do
        geo_route { Rack::Test::UploadedFile.new('spec/fixtures/geo_route.tcx', 'application/xml') }
      end
    end
  end
end
