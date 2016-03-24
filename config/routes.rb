require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users
  # API definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      
      resources :users, :only => [:create, :destroy]
      resources :sessions, :only => [:create, :destroy]
      resources :institutions, :only => [:index, :show, :create, :update, :destroy]
      resources :domains, :only => [:index, :show, :create, :update, :destroy]
      resources :video_moments, :only => [:show, :update, :destroy]
      resources :question_hints, :only => [:show, :update, :destroy]
      resources :student_video_snapshots, :only => [:create, :update, :destroy]
      resources :announcements, :only => [:index, :show, :create, :update, :destroy]
      resources :notifications, :only => [:index, :show, :update]
      resources :section_settings, :only => [:show, :update, :destroy]
      resources :contact, :only => [:create]
      
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
      get '/courses/:id/video_moments', to: 'courses#list_video_moments'
      get '/courses/:id/authors', to: 'courses#list_authors'
      post '/courses/:id/authors', to: 'courses#add_authors'
      post '/courses/:id/notify', to: 'courses#notify'

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
      post '/sections/:id/feedback', to: 'sections#feedback'
      post '/sections/:id/video_moments', to: 'sections#add_video_moment'
      get '/sections/:id/video_moments', to: 'sections#list_video_moments'
      post '/sections/:id/settings', to: 'sections#add_setting'
      get '/sections/:id/settings', to: 'sections#list_settings'
      post '/sections/:id/start', to: 'sections#start'

      # Delete video
      delete '/delete-assets/:id', to: 'courses#assets'

      # Question Routes
      get '/questions', to: 'questions#index'
      get '/questions/:id', to: 'questions#show'
      post '/questions', to: 'questions#create'
      put '/questions/:id', to: 'questions#update'      
      delete '/questions/:id', to: 'questions#destroy'

      post '/questions/:id/answers', to: 'questions#add_answer'
      get '/questions/:id/answers', to: 'questions#list_answers'

      post '/questions/:id/hints', to: 'questions#add_hint'
      get '/questions/:id/hints', to: 'questions#list_hints'

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
      get '/users/facebook_check', to: 'users#facebook_check'
      get '/users/:id', to: 'users#show'
      put '/users/:id', to: 'users#update'
      post '/users/change_password', to: 'users#change_password'
      get '/users/:id/institution', to: 'users#institution'
      post '/users/check_username', to: 'users#check_username_availability'
      post '/users/check_email', to: 'users#check_email_availability'      
      get '/users/:id/courses', to: "users#courses"

      # Invitation Routes
      post '/invitations', to: 'invitations#create'
      post '/invitations/check', to: 'invitations#check'
      # get '/invitations', to: 'invitations#index'      

      # Waiting List Routes
      get '/waiting-list', to: 'waiting_list#index'
      post '/waiting-list', to: 'waiting_list#create'

      # Image Routes
      post '/images/process_image', to: 'images#process_image'

      # Domain Routes
      post '/domains/:id/categories', to: 'domains#add_category'
      get '/domains/:id/categories', to: 'domains#list_categories'

      # Category Routes
      get '/categories/:id', to: 'categories#show'
      put '/categories/:id', to: 'categories#update'
      delete '/categories/:id', to: 'categories#destroy'
      get '/categories/:id/courses', to: 'categories#list_courses'

      # Temporary Routes - Deploy scripts
      post 'slugify', to: 'courses#temporary_slugify'      
    end
  end
end