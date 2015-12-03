class RemoveApplicationSettings < ActiveRecord::Migration
  def change
    drop_table :application_settings, if_exists: true
  end
end
