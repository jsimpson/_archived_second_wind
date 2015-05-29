require 'spec_helper'

describe Activity, type: :model do
  context 'run with a geo route file' do
    Broutes.logger.level = Logger::FATAL
    let(:run) { FactoryGirl.create(:run_with_geo_route) }
    subject { run }

    describe '#update_route' do
      it 'should set the fields from the geo route file' do
        expect(run.started_at).to eql(DateTime.new(2014, 07, 27, 6, 33, 46, '-7').to_time)
        expect(run.ended_at).to eql(DateTime.new(2014, 07, 27, 9, 01, 00, '-7').to_time)
        expect(run.total_elevation_gain).to be_within(0.1).of(526.79)
        expect(run.total_elevation_loss).to be_within(0.1).of(449.79)
        expect(run.total_time).to eql(8834.0)
        expect(run.total_distance).to eql(21_446)
        expect(run.average_speed).to be_within(0.1).of(2.40)
        expect(run.max_elevation).to be_within(0.1).of(94.8)
        expect(run.min_elevation).to be_within(0.1).of(-11.0)
        expect(run.max_heart_rate).to eql(173)
        expect(run.min_heart_rate).to eql(111)
        expect(run.average_heart_rate).to eql(154)
      end
    end

    describe '#elapsed_time' do
      it 'should return the elapsed time string' do
        expect(run.elapsed_time).to eql('02:27:14')
      end
    end

    describe '#get_total_distance' do
      it 'should convert the distance to miles' do
        expect(run.total_distance).to eql(21_446)
        expect(run.get_total_distance).to be_within(2).of(13.33)
      end
    end

    describe '#get_average_speed' do
      it 'should convert the average speed to miles per hour' do
        expect(run.average_speed).to be_within(0.1).of(2.40)
        expect(run.get_average_speed).to be_within(0.1).of(5.37)
      end
    end
  end
end
