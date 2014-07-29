Rails.application.routes.draw do
  devise_for :users
  devise_for :vendors
  root to: 'high_voltage/pages#show', id: 'splash'
end
