require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users
  # API definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      
    	resources :users, :only => [:show, :create, :update, :destroy] # owner
      resources :sessions, :only => [:create, :destroy] # all
      resources :institutions, :only => [:index, :show, :create, :update, :destroy] # owner

      # Course Routes
      get '/courses', to: 'courses#admin_index', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/courses', to: 'courses#estudent_index', constraints: RoleRouteConstraint.new(User::ROLES[:estudent])
      get '/courses/:id', to: 'courses#admin_show', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/courses/:id', to: 'courses#estudent_show', constraints: RoleRouteConstraint.new(User::ROLES[:estudent])
      post '/courses', to: 'courses#create', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      put '/courses/:id', to: 'courses#update', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      delete '/courses/:id', to: 'courses#destroy', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      post '/courses/:id/chapters', to: 'courses#add_chapter', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/courses/:id/chapters', to: 'courses#list_chapters', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Chapter Routes
      get '/chapters', to: 'chapters#index'
      get '/chapters/:id', to: 'chapters#show'
      post '/chapters', to: 'chapters#create', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      put '/chapters/:id', to: 'chapters#update', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      delete '/chapters/:id', to: 'chapters#destroy', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      post '/chapters/:id/sections', to: 'chapters#add_section', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/chapters/:id/sections', to: 'chapters#list_sections', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Section Routes
      get '/sections', to: 'sections#index'
      get '/sections/:id', to: 'sections#show'
      post '/sections', to: 'sections#create', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      put '/sections/:id', to: 'sections#update', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      delete '/sections/:id', to: 'sections#destroy', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      post '/sections/:id/questions', to: 'sections#add_question', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/sections/:id/questions', to: 'sections#list_questions', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Question Routes
      get '/questions', to: 'questions#index'
      get '/questions/:id', to: 'questions#show'
      post '/questions', to: 'questions#create', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      put '/questions/:id', to: 'questions#update', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      delete '/questions/:id', to: 'questions#destroy', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      post '/questions/:id/answers', to: 'questions#add_answer', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/questions/:id/answers', to: 'questions#list_answers', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Answer Routes
      get '/answers', to: 'answers#index'
      get '/answers/:id', to: 'answers#show'
      post '/answers', to: 'answers#create', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      put '/answers/:id', to: 'answers#update', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      delete '/answers/:id', to: 'answers#destroy', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      
      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      
      # User Routes
      post '/institutions/:id/users', to: 'institutions#create_users', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/institutions/:id/users', to: 'institutions#list_users', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/institutions/:id/courses', to: 'institutions#list_courses', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

    end
  end
end
