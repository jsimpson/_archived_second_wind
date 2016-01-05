Rails.application.routes.draw do
  resources :activities, only: [ :index, :show ]

  root 'activities#index'

  get 'lifetime_monthly_mileage' => 'activities#mileage', :as => :activities_mileage

  get 'activity/:id/heart_rate' => 'activities#heart_rate', :as => :heart_rate
  get 'activity/:id/elevation' => 'activities#elevation', :as => :elevation
  get 'activity/:id/speed' => 'activities#speed', :as => :speed
  get 'activity/:id/heart_rate_intensity' => 'activities#heart_rate_intensity', :as => :heart_rate_intensity
end
