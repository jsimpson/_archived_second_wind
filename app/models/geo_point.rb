class GeoPoint < ActiveRecord::Base
  belongs_to :activity

  default_scope -> { order('time DESC') }
end
