require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :vendors, path: 'vendors', path_names: { sign_in: 'login', 
  																									sign_out: 'logout' },
  															      controllers: { sessions: 'vendors/sessions',
	  									 				      						registrations: 'vendors/registrations',
			  									 				      						passwords: 'passwords' }

  devise_for :users, controllers: { sessions: 'users/sessions',
										 				   registrations: 'users/registrations',
				 				      						 passwords: 'passwords' }

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
	  resources :transactions, except: :index
	end

	match 'users/:id/uuid_credit' => 'users#uuid_credit', as: 'user_uuid_credit', via: :patch

  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'high_voltage/pages#show', id: 'splash'
end
