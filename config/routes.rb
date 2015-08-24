require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # API definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
    	resources :users, :only => [:show, :create, :update, :destroy]
      resources :sessions, :only => [:create, :destroy]
      resources :institutions, :only => [:show, :create, :update, :destroy, :index]

      post '/institutions/:id/users', to: 'institutions#create_users'
      get '/institutions/:id/users', to: 'institutions#list_users'
    end
  end
end
