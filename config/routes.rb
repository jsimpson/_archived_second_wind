Rails.application.routes.draw do
  resources :activities
  root 'activities#index'
end
