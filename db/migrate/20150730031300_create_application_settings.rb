class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.boolean :imperial, null: false, default: false

      t.timestamps null: false
    end
  end
end
