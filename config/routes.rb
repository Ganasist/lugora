require 'sidekiq/web'

Rails.application.routes.draw do

  resources :tokens

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :vendors, path: 'vendors', path_names: { sign_in: 'login', 
  																									sign_out: 'logout' },
  															      controllers: { sessions: 'vendors/sessions',
	  									 				      						registrations: 'vendors/registrations',
			  									 				      						passwords: 'passwords',
										 				      						  confirmations: 'confirmations' }

  devise_for :users, controllers: { sessions: 'users/sessions',
										 				   registrations: 'users/registrations',
				 				      						 passwords: 'passwords',
		 				      						 confirmations: 'confirmations' }

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

	resources :users, only: :show do
		resources :transactions, :products, :vendors, only: [:show, :index]
	end

	resources :vendors, only: [:show, :index], shallow: true  do
	  resources :products do
		  resources :transactions
		end
		resources :transactions
	end

	# match 'users/:id/uuid_credit' => 'users#uuid_credit', as: 'user_uuid_credit', via: :patch

  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'high_voltage/pages#show', id: 'splash'
end
