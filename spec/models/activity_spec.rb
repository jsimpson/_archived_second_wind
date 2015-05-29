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
  end

  context 'any activity' do
    let(:activity) { FactoryGirl.build(:activity_with_summary) }
    subject { activity }

    describe '#elapsed_time' do
      it 'should return the elapsed time string' do
        expect(activity.elapsed_time).to eql('02:27:14')
      end
    end

    describe '#get_total_distance' do
      it 'should convert the distance to miles' do
        expect(activity.total_distance).to eql(21_446)
        expect(activity.get_total_distance).to be_within(2).of(13.33)
      end
    end

    describe '#get_average_speed' do
      it 'should convert the average speed to miles per hour' do
        expect(activity.average_speed).to be_within(0.1).of(2.40)
        expect(activity.get_average_speed).to be_within(0.1).of(5.37)
      end
    end

    describe '#get_average_pace' do
      it 'should return the average pace string in minutes per mile format' do
        expect(activity.get_average_pace).to eql('11:10')
      end
    end

    describe '#get_max_speed' do
      it 'should convert the max speed from kilometers per hour to miles per hour' do
        expect(activity.max_speed).to be_within(0.1).of(4.19)
        expect(activity.get_max_speed).to be_within(0.1).of(9.37)
      end
    end

    describe '#get_min_speed' do
      pending 'needs to be implemented...'
    end

    describe '#get_min_pace' do
      pending 'needs to be implemented...'
    end

    describe '#get_max_pace' do
      it 'should return the max pace string in miutes per mile format' do
        expect(activity.get_max_pace).to eql('06:24')
      end
    end

    describe '#get_total_elevation_gain' do
      it 'should convert the total elevation gain from meters to feet' do
        expect(activity.total_elevation_gain).to be_within(0.1).of(526.7)
        expect(activity.get_total_elevation_gain).to be_within(0.1).of(1728.3)
      end
    end

    describe '#get_total_elevation_loss' do
      it 'should convert the total elevation loss from meters to feet' do
        expect(activity.total_elevation_loss).to be_within(0.1).of(449.7)
        expect(activity.get_total_elevation_loss).to be_within(0.1).of(1475.6)
      end
    end

    describe '#get_max_elevation' do
      it 'should convert the max elevation from meters to feet' do
        expect(activity.max_elevation).to be_within(0.1).of(94.8)
        expect(activity.get_max_elevation).to be_within(0.1).of(311.0)
      end
    end

    describe '#get_min_elevation' do
      it 'should convert the min elevation from meters to feet' do
        expect(activity.min_elevation).to be_within(0.1).of(-11.0)
        expect(activity.get_min_elevation).to be_within(0.1).of(-36.0)
      end
    end
  end
end
