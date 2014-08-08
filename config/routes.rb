require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :vendors, controllers: { sessions: 'vendors/sessions',
	  									 					 registrations: 'vendors/registrations' }

  devise_for :users,   controllers: { sessions: 'users/sessions',
										  				   registrations: 'users/registrations' }

	authenticated :user do
	  devise_scope :user do
	    root to: 'users#show', as: :authenticated_user
	  end
	end

	authenticated :vendor do
	  devise_scope :vendor do
	    root to: 'vendors#show', as: :authenticated_vendor
	  end
	end

	resources :users, only: [:show, :index] do
		resources :transactions, only: [:show, :index]
	end

	resources :vendors, only: [:show, :index] do
	  resources :transactions
	end

  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'high_voltage/pages#show', id: 'splash'
end
