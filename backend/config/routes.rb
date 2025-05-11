Rails.application.routes.draw do
  # signup & login & jwt
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  get '/me', to: 'profiles#show'  # 로그인된 사용자 정보 조회

  # workspace
  post '/workspaces', to: 'workspaces#create'
  get '/workspaces', to: 'workspaces#index'

  # task
  resources :workspaces do
    resources :tasks, only: [:index, :create, :update, :destroy] do
      member do
        patch :toggle_status # /workspaces/:workspace_id/tasks/:id/toggle_status
      end
    end
  end
end