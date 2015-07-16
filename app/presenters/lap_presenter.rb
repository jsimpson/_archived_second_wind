class LapPresenter
  def initialize(lap)
    @lap = lap
  end

  def elapsed_time
    format('%02d:%02d:%02d',
      hours(@lap.total_time),
      minutes(@lap.total_time),
      seconds(@lap.total_time))
  end

  def total_distance
    @lap.distance * 0.000621371
  end

  def average_pace
    return '00:00' if @lap.average_speed == 0.0
    pace(@lap.average_speed)
  end

  private

  attr_reader :lap

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
