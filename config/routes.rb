require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users
  # API definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: ENV["SUDBOMAIN"] }, path: '/' do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      
    	resources :users, :only => [:show, :create, :destroy] # owner
      resources :sessions, :only => [:create, :destroy] # all
      resources :institutions, :only => [:index, :show, :create, :update, :destroy] # owner

      # constraints = RoleRouteConstraint.new(User::ROLES[:admin])
      # estudent_constraints = RoleRouteConstraint.new(User::ROLES[:estudent])
      
      # Course Routes
      get '/courses', to: 'courses#admin_index'#, constraints: constraints
      get '/estudent_courses', to: 'courses#estudent_index'#, constraints: estudent_constraints
      get '/estudent_courses/latest_course', to: 'users#latest_course'#, constraints: estudent_constraints
      post '/estudent_courses/:id/reset', to: 'courses#reset'#, constraints: estudent_constraints
      get '/courses/:id', to: 'courses#show'#, constraints: constraints
      get '/estudent_courses/:id', to: 'courses#estudent_show'#, constraints: estudent_constraints
      post '/courses', to: 'courses#create'#, constraints: constraints
      put '/courses/:id', to: 'courses#update'#, constraints: constraints      
      delete '/courses/:id', to: 'courses#destroy'#, constraints: constraints
      post '/estudent_courses/:id/start', to: 'courses#start'#, constraints: estudent_constraints
      post '/courses/:id/chapters', to: 'courses#add_chapter'#, constraints: constraints
      get '/courses/:id/chapters', to: 'courses#list_chapters'#, constraints: constraints
      
      # Chapter Routes
      get '/chapters', to: 'chapters#index'
      get '/chapters/:id', to: 'chapters#show'
      post '/chapters', to: 'chapters#create'#, constraints: constraints
      put '/chapters/:id', to: 'chapters#update'#, constraints: constraints
      delete '/chapters/:id', to: 'chapters#destroy'#, constraints: constraints

      post '/chapters/:id/sections', to: 'chapters#add_section'#, constraints: constraints
      get '/chapters/:id/sections', to: 'chapters#list_sections'#, constraints: constraints

      # Section Routes
      get '/sections', to: 'sections#index'
      get '/sections/:id', to: 'sections#show'
      post '/sections', to: 'sections#create'#, constraints: constraints
      put '/sections/:id', to: 'sections#update'#, constraints: constraints
      put '/estudent_sections/:id', to: 'sections#estudent_update'#, constraints: estudent_constraints
      delete '/sections/:id', to: 'sections#destroy'#, constraints: constraints

      post '/sections/:id/questions', to: 'sections#add_question'#, constraints: constraints
      get '/sections/:id/questions', to: 'sections#list_questions'#, constraints: constraints

      # Question Routes
      get '/questions', to: 'questions#index'
      get '/questions/:id', to: 'questions#show'
      post '/questions', to: 'questions#create'#, constraints: constraints
      put '/questions/:id', to: 'questions#update'#, constraints: constraints
      put '/estudent_questions/:id', to: 'questions#estudent_update'#, constraints: estudent_constraints
      delete '/questions/:id', to: 'questions#destroy'#, constraints: constraints

      post '/questions/:id/answers', to: 'questions#add_answer'#, constraints: constraints
      get '/questions/:id/answers', to: 'questions#list_answers'#, constraints: constraints

      # Answer Routes
      get '/answers', to: 'answers#index'
      get '/answers/:id', to: 'answers#show'
      post '/answers', to: 'answers#create'#, constraints: constraints
      put '/answers/:id', to: 'answers#update'#, constraints: constraints
      delete '/answers/:id', to: 'answers#destroy'#, constraints: constraints
      
      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      post '/sessions/reset_password', to: 'sessions#reset_password'
      
      # Institution Routes
      post '/institutions/:id/users', to: 'institutions#create_users'#, constraints: constraints
      get '/institutions/:id/users', to: 'institutions#list_users'#, constraints: constraints
      get '/institutions/:id/courses', to: 'institutions#list_courses'#, constraints: constraints

      # User Routes      
      put '/estudent_users/:id', to: 'users#estudent_update'#, constraints: estudent_constraints
      put '/users/:id', to: 'users#update'#, constraints: constraints
      post '/estudent_users/change_password', to: 'users#change_password'#, constraints: estudent_constraints

      # Invitation Routes
      post '/invitations', to: 'invitations#create'#, constraints: constraints
      post '/invitations/check', to: 'invitations#check'
      get '/invitations', to: 'invitations#index'      

      # Waiting List Routes
      get '/waiting-list', to: 'waiting_list#index'#, constraints: constraints
      post '/waiting-list', to: 'waiting_list#create'

      # Image Routes
      post '/images/process_image', to: 'images#process_image'

      # Delete content asset
      delete '/content_assets/:id', to: 'sections#content_asset'#, constraints: constraints

    end
  end
end
