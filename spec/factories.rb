FactoryGirl.define do
  factory :activity do
    logged_date "2015-03-01 00:46:32"
    start_time "2015-03-01 00:46:32"
    end_time "2015-03-01 00:46:32"
    total_elevation_gain "9.99"
    total_elevation_loss "9.99"
    total_time 1
    total_distance "9.99"
    average_speed "9.99"
    average_pace "9.99"
    max_elevation "9.99"
    min_elevation "9.99"
    max_heart_rate 1
    min_heart_rate 1
    average_heart_rate 1
    total_calories 1
    quality "9.99"

    factory :run do
      type "Running"
    end

    factory :ride do
      type "Cycling"
    end
  end
end
