namespace :app_settings do
  task imperial: :environment do
    ApplicationSetting.destroy_all
    ApplicationSetting.create(imperial: true)
  end

  task metric: :environment do
    ApplicationSetting.destroy_all
    ApplicationSetting.create(imperial: false)
  end
end
