class RemoveTypeFromActivity < ActiveRecord::Migration
  def change
    remove_column :activities, :type, :string
  end
end
