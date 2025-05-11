Rails.application.routes.draw do
  # admin(관리자)용 집계 결과 조회
  namespace :admin do
    resources :task_progress_reports, only: [:index]
  end

  # signup & login & jwt
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  get '/me', to: 'profiles#show'

  # workspace
  resources :workspaces, only: [:create, :index] do
    # task
    resources :tasks, only: [:index, :create, :update, :destroy] do
      member do
        patch :toggle_status
      end
    end
  end
end