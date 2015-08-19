require 'spec_helper'

describe LapPresenter do
  context 'any lap' do
    let(:lap) { FactoryGirl.build(:lap) }
    let(:presenter) { LapPresenter.new(lap) }
    subject { presenter }

    describe '#elapsed_time' do
      it 'should return the elapsed time string' do
        expect(presenter.elapsed_time).to eql('00:06:07')
      end
    end

    describe '#total_distance' do
      it 'should convert the distance to miles' do
        expect(lap.distance).to eql(1_112)
        expect(presenter.total_distance).to eql('0.69 miles')
      end
    end

    describe '#average_pace' do
      it 'should return the average pace string in minutes per mile format' do
        expect(presenter.average_pace).to eql('11:10 min/mile')
      end
    end
  end
end
