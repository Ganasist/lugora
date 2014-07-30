Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions',
															 registrations: 'users/registrations' }

  devise_for :vendors, controllers: { sessions: 'vendors/sessions',
	  														 registrations: 'vendors/registrations' }

  root to: 'high_voltage/pages#show', id: 'splash'
end
