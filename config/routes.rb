Rails.application.routes.draw do

  devise_for :vendors, path: '', path_names: { sign_in: 'vendor_login',
                                              sign_out: 'vendor_logout',
                                               sign_up: 'vendor_register' },
                                controllers: { sessions: 'vendors/sessions',
	  														 					registrations: 'vendors/registrations' }

  devise_for :users, path: '', path_names: { sign_in: 'user_login',
                                            sign_out: 'user_logout',
                                             sign_up: 'user_register' },
                              controllers: { sessions: 'users/sessions',
															 					registrations: 'users/registrations' }

	authenticated :user do
	  devise_scope :user do
	    root to: "users#show", as: :authenticated_user
	  end
	end

	authenticated :vendor do
	  devise_scope :vendor do
	    root to: "vendors#show", as: :authenticated_vendor
	  end
	end

	resources :users, only: [:show, :index]
	resources :vendors, only: [:show, :index]

  root to: 'high_voltage/pages#show', id: 'splash'
end
