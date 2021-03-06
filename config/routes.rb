Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'
  post 'result', to: 'pages#result'
  post 'github_result', to: 'pages#github_result'
  post 'so_result', to: 'pages#so_result'
  get 'result', to: redirect('/')
  
  namespace :api do
    namespace :v1 do
      get 'github' => "github#index"
      get 'stackoverflow' => "stackoverflow#index"
    end
  end

end
