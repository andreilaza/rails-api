require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users
  # API definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      
      resources :users, :only => [:create, :destroy] # owner
      resources :sessions, :only => [:create, :destroy] # all
      resources :institutions, :only => [:index, :show, :create, :update, :destroy] # owner      

      # Course Routes
      get '/courses', to: 'courses#index'
      get '/courses/latest_course', to: 'users#latest_course'
      post '/courses/:id/reset', to: 'courses#reset'
      get '/courses/:id', to: 'courses#show'      
      post '/courses', to: 'courses#create'
      put '/courses/:id', to: 'courses#update'
      delete '/courses/:id', to: 'courses#destroy'
      post '/courses/:id/start', to: 'courses#start'
      post '/courses/:id/chapters', to: 'courses#add_chapter'
      get '/courses/:id/chapters', to: 'courses#list_chapters'
      
      # Chapter Routes
      get '/chapters', to: 'chapters#index'
      get '/chapters/:id', to: 'chapters#show'
      post '/chapters', to: 'chapters#create'
      put '/chapters/:id', to: 'chapters#update'
      delete '/chapters/:id', to: 'chapters#destroy'

      post '/chapters/:id/sections', to: 'chapters#add_section'
      get '/chapters/:id/sections', to: 'chapters#list_sections'

      # Section Routes
      get '/sections', to: 'sections#index'
      get '/sections/:id', to: 'sections#show'
      post '/sections', to: 'sections#create'
      put '/sections/:id', to: 'sections#update'      
      delete '/sections/:id', to: 'sections#destroy'

      post '/sections/:id/questions', to: 'sections#add_question'
      get '/sections/:id/questions', to: 'sections#list_questions'
      
      # Delete video
      delete '/content_assets/:id', to: 'sections#content_asset'

      # Question Routes
      get '/questions', to: 'questions#index'
      get '/questions/:id', to: 'questions#show'
      post '/questions', to: 'questions#create'
      put '/questions/:id', to: 'questions#update'      
      delete '/questions/:id', to: 'questions#destroy'

      post '/questions/:id/answers', to: 'questions#add_answer'
      get '/questions/:id/answers', to: 'questions#list_answers'

      # Answer Routes
      get '/answers', to: 'answers#index'
      get '/answers/:id', to: 'answers#show'
      post '/answers', to: 'answers#create'
      put '/answers/:id', to: 'answers#update'
      delete '/answers/:id', to: 'answers#destroy'
      
      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      post '/sessions/reset_password', to: 'sessions#reset_password'
      
      # Institution Routes
      post '/institutions/:id/users', to: 'institutions#create_users'
      get '/institutions/:id/users', to: 'institutions#list_users'
      get '/institutions/:id/courses', to: 'institutions#list_courses'

      # User Routes
      get '/users/current_user', to: 'users#current'
      get '/users/:id', to: 'users#show'
      put '/users/:id', to: 'users#update'
      post '/users/change_password', to: 'users#change_password'
      get '/users/:id/institution', to: 'users#institution'      

      # Invitation Routes
      post '/invitations', to: 'invitations#create'
      post '/invitations/check', to: 'invitations#check'
      get '/invitations', to: 'invitations#index'      

      # Waiting List Routes
      get '/waiting-list', to: 'waiting_list#index'
      post '/waiting-list', to: 'waiting_list#create'

      # Image Routes
      post '/images/process_image', to: 'images#process_image'      

    end
  end
end