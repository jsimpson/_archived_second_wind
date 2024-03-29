require 'spec_helper'

describe Activity, type: :model do
  context 'run with a geo route file' do
    logger = Logger.new(STDOUT)
    logger.level = Logger::FATAL
    Geocoder.configure(logger: logger)
    Broutes.logger.level = Logger::FATAL

    before do
      VCR.use_cassette('geocoder') do
        activity = FactoryGirl.create(:run_with_geo_route)
        activity.save
        @run = Activity.find(activity.id)
      end
    end

    describe '#update_route' do
      it 'should set the fields from the geo route file' do
        VCR.use_cassette('geocoder') do
          expect(@run.started_at).to eql(DateTime.new(2014, 07, 27, 6, 33, 46, '-7').to_time)
          expect(@run.ended_at).to eql(DateTime.new(2014, 07, 27, 9, 01, 00, '-7').to_time)
          expect(@run.total_elevation_gain).to be_within(0.1).of(526.79)
          expect(@run.total_elevation_loss).to be_within(0.1).of(449.79)
          expect(@run.total_time).to eql(8_834)
          expect(@run.total_distance).to eql(21_446)
          expect(@run.average_speed).to be_within(0.1).of(2.40)
          expect(@run.max_elevation).to be_within(0.1).of(94.8)
          expect(@run.min_elevation).to be_within(0.1).of(-11.0)
          expect(@run.max_heart_rate).to eql(173)
          expect(@run.min_heart_rate).to eql(111)
          expect(@run.average_heart_rate).to eql(154)
          expect(@run.speed_trend).to eql(0)
          expect(@run.sport).to eql('Running')
          expect(@run.latitude).to be_within(0.1).of(37.79338616877794)
          expect(@run.longitude).to be_within(0.1).of(-122.39200889132917)
          expect(@run.full_address).to eql('3-109 The Embarcadero, San Francisco, CA 94105, USA')
          expect(@run.city).to eql('San Francisco')
          expect(@run.state).to eql('California')
          expect(@run.country).to eql('United States')
          expect(@run.country_code).to eql('US')
          expect(@run.geo_route_processed).to eql(true)
        end
      end

      it 'should create the laps and geo_points for the activity' do
        VCR.use_cassette('geocoder') do
          expect(@run.geo_points.count).to eql(1612)
          expect(@run.laps.count).to eql(14)
        end
      end
    end

    describe '#geo_points_lat_lng' do
      it 'should return a hash of latitude and longitude points' do
        VCR.use_cassette('geocoder') do
          expect(@run.geo_points.lat_lng.count).to eq(1602)
        end
      end
    end

    describe '#geo_route_heart_rate' do
      it 'should return a hash of time => heart_rate items' do
        VCR.use_cassette('geocoder') do
          expect(@run.geo_points.heart_rate.count).to eq(1603)
        end
      end
    end

    describe '#geo_route_heart_rate_intensity' do
      it 'should return a hash of heart_rate ranges => counts' do
        VCR.use_cassette('geocoder') do
          expect(@run.geo_points.heart_rate_intensity.count).to eq(7)
        end
      end
    end

    describe '#geo_route_elevation' do
      it 'should return a hash of time => elevation items' do
        VCR.use_cassette('geocoder') do
          expect(@run.geo_points.elevation.count).to eq(1602)
        end
      end
    end

    describe '#geo_route_speed' do
      it 'should return a hash of time => speed items' do
        VCR.use_cassette('geocoder') do
          expect(@run.geo_points.speed.count).to eq(1602)
        end
      end
    end
  end
end
