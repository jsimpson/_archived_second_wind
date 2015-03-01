class Activity < ActiveRecord::Base
  scope :runs, -> { where(type: 'Running') }
  scope :rides, -> { where(type: 'Cycling') }

  def self.types
    %w(Running Cycling)
  end
end
