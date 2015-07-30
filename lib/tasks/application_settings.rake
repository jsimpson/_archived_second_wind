namespace :app_settings do
  task imperial: :environment do
    ApplicationSetting.create(imperial: true)
  end

  task metric: :environment do
    ApplicationSetting.create(imperial: false)
  end
end
