class ActivityPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(activity, use_imperial)
    @activity = activity
    @use_imperial = use_imperial
  end

  def started_at
    @activity.started_at.localtime.to_s(:long)
  end

  def elapsed_time
    format('%02d:%02d:%02d', hours(@activity.total_time), minutes(@activity.total_time), seconds(@activity.total_time))
  end

  def total_distance
    convert(@activity.total_distance, 0.000621371, 2, 'miles', 'meters')
  end

  def total_calories
    "#{number_with_delimiter(@activity.total_calories)}"
  end

  def max_speed
    convert(@activity.max_speed, 2.23694, 2, 'mph', 'km/h')
  end

  def min_speed
    convert(@activity.min_speed, 2.23694, 2, 'mph', 'km/h')
  end

  def average_speed
    convert(@activity.average_speed, 2.23694, 2, 'mph', 'km/h')
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

  private

  attr_reader :activity, :use_imperial

  def convert(value, conversion_ratio, precision, imperial_unit, metric_unit)
    units = metric_unit

    if @use_imperial
      value *= conversion_ratio
      units = imperial_unit
    end

    "#{number_with_precision(value, precision: precision)} #{units}"
  end

  def pace(speed)
    return '00:00' if speed == 0.0
    units = 'min/km'

    if @use_imperial
      pace = (60 / (speed * 2.23694)).to_d
      units = 'min/mile'
    else
      pace = (60 / (speed)).to_d
    end

    seconds = (pace.frac * 60).floor
    format('%02d:%02d %s', pace.fix, seconds, units)
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
    convert(ele, 3.28084, 0, 'ft', 'm')
  end
end
