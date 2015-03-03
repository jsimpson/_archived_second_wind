Rails.application.routes.draw do
  resources :activities
  resources :runs, controller: 'activities', type: 'Run'
  resources :rides, controller: 'activities', type: 'Ride'
  root 'activities#index'
end
