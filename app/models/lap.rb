class Lap < ActiveRecord::Base
  belongs_to :activity

  scope :started_at, -> { order('started_at ASC') }
end
