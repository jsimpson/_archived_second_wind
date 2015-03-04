FactoryGirl.define do
  factory :activity do
    factory :run do
      type "Running"
      factory :run_with_geo_route do
        geo_route { Rack::Test::UploadedFile.new('spec/fixtures/geo_route.tcx', 'application/xml') }
      end
    end
  end
end
