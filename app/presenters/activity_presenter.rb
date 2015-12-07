class ActivityPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(activity)
    @activity = activity
  end

  def started_at
    @activity.started_at.to_s(:month_day_year_slashes)
  end

  def started_at_long
    @activity.started_at.to_s(:long)
  end

  def elapsed_time
    format('%02d:%02d:%02d', hours(@activity.total_time), minutes(@activity.total_time), seconds(@activity.total_time))
  end

  def total_distance
    convert(@activity.total_distance, 0.000621371, 2, 'miles')
  end

  def total_calories
    "#{number_with_delimiter(@activity.total_calories)}"
  end

  def max_speed
    convert(@activity.max_speed, 2.23694, 2, 'mph')
  end

  def min_speed
    convert(@activity.min_speed, 2.23694, 2, 'mph')
  end

  def average_speed
    convert(@activity.average_speed, 2.23694, 2, 'mph')
  end

  def max_pace
    pace(@activity.max_speed)
  end

  def min_pace
    pace(@activity.min_speed)
  end

  def average_pace
    pace(@activity.average_speed)
  end

  def total_elevation_gain
    elevation(@activity.total_elevation_gain)
  end

  def total_elevation_loss
    elevation(@activity.total_elevation_loss)
  end

  def max_elevation
    elevation(@activity.max_elevation)
  end

  def min_elevation
    elevation(@activity.min_elevation)
  end

  def where
    "#{@activity.city}, #{@activity.state} #{@activity.country_code}"
  end

  def trend
    @activity.speed_trend >= 0 ? 'up' : 'down'
  end

  def max_heart_rate
    "#{activity.max_heart_rate} bpm"
  end

  def min_heart_rate
    "#{activity.min_heart_rate} bpm"
  end

  def average_heart_rate
    "#{activity.average_heart_rate} bpm"
  end

  def average_cadence
    "#{activity.average_cadence * 2} spm"
  end

  def maximum_cadence
    "#{activity.max_cadence * 2} spm"
  end

  private

  attr_reader :activity

  def convert(value, conversion_ratio, precision, units)
    value *= conversion_ratio
    "#{number_with_precision(value, delimiter: ',', precision: precision)} #{units}"
  end

  def pace(speed)
    return '00:00' if speed == 0.0

    pace = (60 / (speed * 2.23694)).to_d
    seconds = (pace.frac * 60).floor
    format('%02d:%02d %s', pace.fix, seconds, 'min/mile')
  end

  def seconds(t)
    t % 60
  end

  def minutes(t)
    (t / 60) % 60
  end

  def hours(t)
    t / 3600
  end

  def elevation(ele)
    convert(ele, 3.28084, 0, 'ft')
  end
end
