class Lap < ActiveRecord::Base
  belongs_to :activity

  scope :started_at, -> { order('start_time ASC') }
end
