class AddAddressDataToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :full_address, :string
    add_column :activities, :city, :string
    add_column :activities, :state, :string
    add_column :activities, :country, :string
    add_column :activities, :country_code, :string
  end
end
