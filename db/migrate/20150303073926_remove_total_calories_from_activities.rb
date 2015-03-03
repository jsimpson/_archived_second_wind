class RemoveTotalCaloriesFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :total_calories
  end
end
