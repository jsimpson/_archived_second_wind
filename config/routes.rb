Rails.application.routes.draw do
  resources :activities, only: [ :index, :show, :destroy ]
  resources :runs, controller: 'activities', type: 'Run', only: [ :index, :show, :destroy ]
  resources :rides, controller: 'activities', type: 'Ride', only: [ :index, :show, :destroy ]

  root 'activities#index'

  get 'lifetime_monthly_mileage' => 'activities#mileage', :as => :activities_mileage
  get 'analytics' => 'activities#analytics', :as => :activities_analytics
  get 'activity/:id/heart_rate' => 'activities#heart_rate', :as => :heart_rate
  get 'activity/:id/elevation' => 'activities#elevation', :as => :elevation
  get 'activity/:id/speed' => 'activities#speed', :as => :speed
end
