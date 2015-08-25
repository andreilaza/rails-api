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
      resources :institutions, :only => [:index, :show, :create, :update, :destroy]
      resources :courses, :only => [:index, :show, :create, :update, :destroy]
      resources :chapters, :only => [:index, :show, :create, :update, :destroy]

      post '/institutions/:id/users', to: 'institutions#create_users'
      get '/institutions/:id/users', to: 'institutions#list_users'
      get '/institutions/:id/courses', to: 'institutions#list_courses'

      # Course Routes
      post '/courses/:id/chapters', to: 'courses#add_chapter'
      get '/courses/:id/chapters', to: 'courses#list_chapters'

    end
  end
end
