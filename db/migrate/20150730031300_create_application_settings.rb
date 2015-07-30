class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.boolean :imperial, null: false, defaukt: false

      t.timestamps null: false
    end
  end
end
