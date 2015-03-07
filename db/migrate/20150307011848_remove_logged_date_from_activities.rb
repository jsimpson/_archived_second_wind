class RemoveLoggedDateFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :logged_date
  end
end
