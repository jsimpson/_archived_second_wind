class GeoPoint < ActiveRecord::Base
  belongs_to :activity

  default_scope -> { order('time ASC') }
end
