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
      # resources :courses, :only => [:index, :show, :create, :update, :destroy] # admin & estudent
      resources :chapters, :only => [:index, :show, :create, :update, :destroy] # admin & estudent
      resources :sections, :only => [:index, :show, :create, :update, :destroy] # admin & estudent
      resources :questions, :only => [:index, :show, :create, :update, :destroy] # admin & estudent
      resources :answers, :only => [:index, :show, :create, :update, :destroy] # admin & estudent


      # Course Routes      
      get '/courses', to: 'courses#admin_index', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/courses', to: 'courses#estudent_index', constraints: RoleRouteConstraint.new(User::ROLES[:estudent])
      get '/courses/:id', to: 'courses#admin_show', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/courses/:id', to: 'courses#estudent_show', constraints: RoleRouteConstraint.new(User::ROLES[:estudent])
      post '/courses', to: 'courses#create', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      put '/courses/:id', to: 'courses#update', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      delete '/courses/:id', to: 'courses#destroy', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      
      # User Routes
      post '/institutions/:id/users', to: 'institutions#create_users', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/institutions/:id/users', to: 'institutions#list_users', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/institutions/:id/courses', to: 'institutions#list_courses', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Course Routes
      post '/courses/:id/chapters', to: 'courses#add_chapter', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/courses/:id/chapters', to: 'courses#list_chapters', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Chapter Routes
      post '/chapters/:id/sections', to: 'chapters#add_section', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/chapters/:id/sections', to: 'chapters#list_sections', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Section Routes
      post '/sections/:id/questions', to: 'sections#add_question', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/sections/:id/questions', to: 'sections#list_questions', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

      # Question Routes
      post '/questions/:id/answers', to: 'questions#add_answer', constraints: RoleRouteConstraint.new(User::ROLES[:admin])
      get '/questions/:id/answers', to: 'questions#list_answers', constraints: RoleRouteConstraint.new(User::ROLES[:admin])

    end
  end
end
