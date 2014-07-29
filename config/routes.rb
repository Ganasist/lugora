Rails.application.routes.draw do
	
  devise_for :vendors
  root to: 'visitors#index'
  devise_for :users
end
