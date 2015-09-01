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
      resources :sections, :only => [:index, :show, :create, :update, :destroy]
      resources :questions, :only => [:index, :show, :create, :update, :destroy]
      resources :answers, :only => [:index, :show, :create, :update, :destroy]

      match '/answers(/:id)' => 'answers#options', via: [:options]

      # Session Routes
      post '/sessions/signup', to: 'sessions#signup'
      
      # User Routes
      post '/institutions/:id/users', to: 'institutions#create_users'
      get '/institutions/:id/users', to: 'institutions#list_users'
      get '/institutions/:id/courses', to: 'institutions#list_courses'

      # Course Routes
      post '/courses/:id/chapters', to: 'courses#add_chapter'
      get '/courses/:id/chapters', to: 'courses#list_chapters'

      # Chapter Routes
      post '/chapters/:id/sections', to: 'chapters#add_section'
      get '/chapters/:id/sections', to: 'chapters#list_sections'

      # Section Routes
      post '/sections/:id/questions', to: 'sections#add_question'
      get '/sections/:id/questions', to: 'sections#list_questions'

      # Question Routes
      post '/questions/:id/answers', to: 'questions#add_answer'
      get '/questions/:id/answers', to: 'questions#list_answers'

    end
  end
end
