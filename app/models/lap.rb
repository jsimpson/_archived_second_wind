class Lap < ActiveRecord::Base
  belongs_to :activity

  default_scope -> { order('start_time ASC') }
end
