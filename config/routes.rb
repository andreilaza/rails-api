require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users
  # API definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      
    	resources :users, :only => [:show, :create, :destroy] # owner
      resources :sessions, :only => [:create, :destroy] # all
      resources :institutions, :only => [:index, :show, :create, :update, :destroy] # owner

      admin_constraints = RoleRouteConstraint.new(User::ROLES[:admin])
      estudent_constraints = RoleRouteConstraint.new(User::ROLES[:estudent])
      # Course Routes
      get '/courses', to: 'courses#admin_index', constraints: admin_constraints
      get '/courses', to: 'courses#estudent_index', constraints: estudent_constraints
      get '/courses/latest_course', to: 'users#latest_course', constraints: estudent_constraints
      post '/courses/:id/reset', to: 'courses#reset', constraints: estudent_constraints
      get '/courses/:id', to: 'courses#admin_show', constraints: admin_constraints
      get '/courses/:id', to: 'courses#estudent_show', constraints: estudent_constraints
      post '/courses', to: 'courses#create', constraints: admin_constraints
      put '/courses/:id', to: 'courses#update', constraints: admin_constraints      
      delete '/courses/:id', to: 'courses#destroy', constraints: admin_constraints
      post '/courses/:id/start', to: 'courses#start', constraints: estudent_constraints



      post '/courses/:id/chapters', to: 'courses#add_chapter', constraints: admin_constraints
      get '/courses/:id/chapters', to: 'courses#list_chapters', constraints: admin_constraints

      # Chapter Routes
      get '/chapters', to: 'chapters#index'
      get '/chapters/:id', to: 'chapters#show'
      post '/chapters', to: 'chapters#create', constraints: admin_constraints
      put '/chapters/:id', to: 'chapters#update', constraints: admin_constraints
      delete '/chapters/:id', to: 'chapters#destroy', constraints: admin_constraints

      post '/chapters/:id/sections', to: 'chapters#add_section', constraints: admin_constraints
      get '/chapters/:id/sections', to: 'chapters#list_sections', constraints: admin_constraints

      # Section Routes
      get '/sections', to: 'sections#index'
      get '/sections/:id', to: 'sections#show'
      post '/sections', to: 'sections#create', constraints: admin_constraints
      put '/sections/:id', to: 'sections#admin_update', constraints: admin_constraints
      put '/sections/:id', to: 'sections#estudent_update', constraints: estudent_constraints
      delete '/sections/:id', to: 'sections#destroy', constraints: admin_constraints

      post '/sections/:id/questions', to: 'sections#add_question', constraints: admin_constraints
      get '/sections/:id/questions', to: 'sections#list_questions', constraints: admin_constraints

      # Question Routes
      get '/questions', to: 'questions#index'
      get '/questions/:id', to: 'questions#show'
      post '/questions', to: 'questions#create', constraints: admin_constraints
      put '/questions/:id', to: 'questions#admin_update', constraints: admin_constraints
      put '/questions/:id', to: 'questions#estudent_update', constraints: estudent_constraints
      delete '/questions/:id', to: 'questions#destroy', constraints: admin_constraints

      post '/questions/:id/answers', to: 'questions#add_answer', constraints: admin_constraints
      get '/questions/:id/answers', to: 'questions#list_answers', constraints: admin_constraints

      # Answer Routes
      get '/answers', to: 'answers#index'
      get '/answers/:id', to: 'answers#show'
      post '/answers', to: 'answers#create', constraints: admin_constraints
      put '/answers/:id', to: 'answers#update', constraints: admin_constraints
      delete '/answers/:id', to: 'answers#destroy', constraints: admin_constraints
      
      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      post '/sessions/reset_password', to: 'sessions#reset_password'
      
      # Institution Routes
      post '/institutions/:id/users', to: 'institutions#create_users', constraints: admin_constraints
      get '/institutions/:id/users', to: 'institutions#list_users', constraints: admin_constraints
      get '/institutions/:id/courses', to: 'institutions#list_courses', constraints: admin_constraints

      # User Routes      
      put '/users/:id', to: 'users#estudent_update', constraints: estudent_constraints
      put '/users/:id', to: 'users#admin_update', constraints: admin_constraints

      # Invitation Routes
      post '/invitations', to: 'invitations#create', constraints: admin_constraints
      post '/invitations/check', to: 'invitations#check'

      # Waiting List Routes
      post '/waiting-list', to: 'waiting_list#create'
    end
  end
end
