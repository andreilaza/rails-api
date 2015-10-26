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

      # admin_constraints = RoleRouteConstraint.new(User::ROLES[:admin])
      # estudent_constraints = RoleRouteConstraint.new(User::ROLES[:estudent])
      
      # Course Routes
      get '/admin_courses', to: 'courses#index'#, constraints: admin_constraints
      get '/estudent_courses', to: 'courses#estudent_index'#, constraints: estudent_constraints
      get '/estudent_courses/latest_course', to: 'users#latest_course'#, constraints: estudent_constraints
      post '/estudent_courses/:id/reset', to: 'courses#reset'#, constraints: estudent_constraints
      get '/admin_courses/:id', to: 'courses#admin_show'#, constraints: admin_constraints
      get '/estudent_courses/:id', to: 'courses#estudent_show'#, constraints: estudent_constraints
      post '/admin_courses', to: 'courses#create'#, constraints: admin_constraints
      put '/admin_courses/:id', to: 'courses#update'#, constraints: admin_constraints      
      delete '/admin_courses/:id', to: 'courses#destroy'#, constraints: admin_constraints
      post '/estudent_courses/:id/start', to: 'courses#start'#, constraints: estudent_constraints
      post '/admin_courses/:id/chapters', to: 'courses#add_chapter'#, constraints: admin_constraints
      get '/admin_courses/:id/chapters', to: 'courses#list_chapters'#, constraints: admin_constraints
      
      # Chapter Routes
      get '/chapters', to: 'chapters#index'
      get '/chapters/:id', to: 'chapters#show'
      post '/admin_chapters', to: 'chapters#create'#, constraints: admin_constraints
      put '/admin_chapters/:id', to: 'chapters#update'#, constraints: admin_constraints
      delete '/admin_chapters/:id', to: 'chapters#destroy'#, constraints: admin_constraints

      post '/admin_chapters/:id/sections', to: 'chapters#add_section'#, constraints: admin_constraints
      get '/admin_chapters/:id/sections', to: 'chapters#list_sections'#, constraints: admin_constraints

      # Section Routes
      get '/sections', to: 'sections#index'
      get '/sections/:id', to: 'sections#show'
      post '/admin_sections', to: 'sections#create'#, constraints: admin_constraints
      put '/admin_sections/:id', to: 'sections#admin_update'#, constraints: admin_constraints
      put '/estudent_sections/:id', to: 'sections#estudent_update'#, constraints: estudent_constraints
      delete '/admin_sections/:id', to: 'sections#destroy'#, constraints: admin_constraints

      post '/admin_sections/:id/questions', to: 'sections#add_question'#, constraints: admin_constraints
      get '/admin_sections/:id/questions', to: 'sections#list_questions'#, constraints: admin_constraints

      # Question Routes
      get '/questions', to: 'questions#index'
      get '/questions/:id', to: 'questions#show'
      post '/admin_questions', to: 'questions#create'#, constraints: admin_constraints
      put '/admin_questions/:id', to: 'questions#admin_update'#, constraints: admin_constraints
      put '/estudent_questions/:id', to: 'questions#estudent_update'#, constraints: estudent_constraints
      delete '/admin_questions/:id', to: 'questions#destroy'#, constraints: admin_constraints

      post '/admin_questions/:id/answers', to: 'questions#add_answer'#, constraints: admin_constraints
      get '/admin_questions/:id/answers', to: 'questions#list_answers'#, constraints: admin_constraints

      # Answer Routes
      get '/answers', to: 'answers#index'
      get '/answers/:id', to: 'answers#show'
      post '/admin_answers', to: 'answers#create'#, constraints: admin_constraints
      put '/admin_answers/:id', to: 'answers#update'#, constraints: admin_constraints
      delete '/admin_answers/:id', to: 'answers#destroy'#, constraints: admin_constraints
      
      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      post '/sessions/reset_password', to: 'sessions#reset_password'
      
      # Institution Routes
      post '/admin_institutions/:id/users', to: 'institutions#create_users'#, constraints: admin_constraints
      get '/admin_institutions/:id/users', to: 'institutions#list_users'#, constraints: admin_constraints
      get '/admin_institutions/:id/courses', to: 'institutions#list_courses'#, constraints: admin_constraints

      # User Routes      
      put '/estudent_users/:id', to: 'users#estudent_update'#, constraints: estudent_constraints
      put '/admin_users/:id', to: 'users#admin_update'#, constraints: admin_constraints
      post '/estudent_users/change_password', to: 'users#change_password'#, constraints: estudent_constraints

      # Invitation Routes
      post '/admin_invitations', to: 'invitations#create'#, constraints: admin_constraints
      post '/invitations/check', to: 'invitations#check'
      get '/invitations', to: 'invitations#index'      

      # Waiting List Routes
      get '/admin_waiting-list', to: 'waiting_list#index'#, constraints: admin_constraints
      post '/waiting-list', to: 'waiting_list#create'

      # Image Routes
      post '/images/process_image', to: 'images#process_image'

      # Delete content asset
      delete '/content_assets/:id', to: 'sections#content_asset'#, constraints: admin_constraints

    end
  end
end
