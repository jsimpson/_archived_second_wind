class AddTotalCaloriesToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :total_calories, :integer
  end
end
