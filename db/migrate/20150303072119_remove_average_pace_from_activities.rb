class RemoveAveragePaceFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :average_pace
  end
end
