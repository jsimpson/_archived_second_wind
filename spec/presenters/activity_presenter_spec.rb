require 'spec_helper'

describe ActivityPresenter do
  context 'any activity in imperial units' do
    let(:activity) { FactoryGirl.build(:activity_with_summary) }
    let(:presenter) { ActivityPresenter.new(activity, true) }
    subject { presenter }

    describe '#elapsed_time' do
      it 'should return the elapsed time string' do
        expect(presenter.elapsed_time).to eql('02:27:14')
      end
    end

    describe '#total_distance' do
      it 'should convert the distance to miles' do
        expect(activity.total_distance).to eql(21_446)
        expect(presenter.total_distance).to eql('13.33 miles')
      end
    end

    describe '#average_speed' do
      it 'should convert the average speed to miles per hour' do
        expect(activity.average_speed).to be_within(0.1).of(2.40)
        expect(presenter.average_speed).to eql('5.37 mph')
      end
    end

    describe '#average_pace' do
      it 'should return the average pace string in minutes per mile format' do
        expect(presenter.average_pace).to eql('11:10 min/mile')
      end
    end

    describe '#max_speed' do
      it 'should convert the max speed from kilometers per hour to miles per hour' do
        expect(activity.max_speed).to be_within(0.1).of(4.19)
        expect(presenter.max_speed).to eql('9.37 mph')
      end
    end

    describe '#min_speed' do
      it 'should convert the min speed from kilometers per hour to miles per hour' do
        expect(activity.min_speed).to be_within(0.1).of(0.3)
        expect(presenter.min_speed).to eql('0.69 mph')
      end
    end

    describe '#max_pace' do
      it 'should return the max pace string in miutes per mile format' do
        expect(presenter.max_pace).to eql('06:24 min/mile')
      end
    end

    describe '#min_pace' do
      it 'should return the min pace string in miutes per mile format' do
        expect(presenter.min_pace).to eql('86:31 min/mile')
      end
    end

    describe '#total_elevation_gain' do
      it 'should convert the total elevation gain from meters to feet' do
        expect(activity.total_elevation_gain).to be_within(0.1).of(526.7)
        expect(presenter.total_elevation_gain).to eql('1728 ft')
      end
    end

    describe '#total_elevation_loss' do
      it 'should convert the total elevation loss from meters to feet' do
        expect(activity.total_elevation_loss).to be_within(0.1).of(449.7)
        expect(presenter.total_elevation_loss).to eql('1476 ft')
      end
    end

    describe '#max_elevation' do
      it 'should convert the max elevation from meters to feet' do
        expect(activity.max_elevation).to be_within(0.1).of(94.8)
        expect(presenter.max_elevation).to eql('311 ft')
      end
    end

    describe '#min_elevation' do
      it 'should convert the min elevation from meters to feet' do
        expect(activity.min_elevation).to be_within(0.1).of(-11.0)
        expect(presenter.min_elevation).to eql('-36 ft')
      end
    end

    describe '#where' do
      it 'should display the location where the activity took place' do
        expect(presenter.where).to include(activity.city)
        expect(presenter.where).to include(activity.state)
        expect(presenter.where).to include(activity.country_code)
      end
    end

    describe "#trend" do
      context 'when the trend is going up' do
        it 'should tell us which glyphicon to display' do
          expect(presenter.trend).to eq('up')
        end
      end

      context 'when the trend is going down' do
        logger = Logger.new(STDOUT)
        logger.level = Logger::FATAL
        Geocoder.configure(logger: logger)
        Broutes.logger.level = Logger::FATAL

        it 'should tell us which glyphicon to display' do
          VCR.use_cassette('geocoder') do
            FactoryGirl.create(:activity, sport: 'Running', average_speed: 10.0)
            slower = FactoryGirl.create(:run_with_geo_route)
            slower_presenter = ActivityPresenter.new(slower, true)

            expect(slower_presenter.trend).to eq('down')
          end
        end
      end
    end
  end
end
