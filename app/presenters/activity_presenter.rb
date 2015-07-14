class ActivityPresenter
  def initialize(activity)
    @activity = activity
  end

  def started_at
    @activity.started_at.localtime.to_s(:long)
  end

  def elapsed_time
    format('%02d:%02d:%02d',
      hours(@activity.total_time),
      minutes(@activity.total_time),
      seconds(@activity.total_time))
  end

  def total_distance
    @activity.total_distance * 0.000621371
  end

  def average_speed
    @activity.average_speed * 2.23694
  end

  def average_pace
    return '00:00' if @activity.average_speed == 0.0
    pace(@activity.average_speed)
  end

  def max_speed
    @activity.max_speed * 2.23694
  end

  def min_speed
    @activity.min_speed * 2.23694
  end

  def max_pace
    return '00:00' if max_speed == 0.0
    pace(@activity.max_speed)
  end

  def min_pace
    return '00:00' if min_speed == 0.0
    pace(@activity.min_speed)
  end

  def total_elevation_gain
    @activity.total_elevation_gain * 3.28084
  end

  def total_elevation_loss
    @activity.total_elevation_loss * 3.28084
  end

  def max_elevation
    @activity.max_elevation * 3.28084
  end

  def min_elevation
    @activity.min_elevation * 3.28084
  end

  private

  attr_reader :activity

  def pace(speed)
    pace = (60 / (speed * 2.23694)).to_d
    seconds = (pace.frac * 60).floor
    format('%02d:%02d', pace.fix, seconds)
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
end
