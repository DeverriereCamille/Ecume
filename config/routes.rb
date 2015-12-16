Rails.application.routes.draw do

  devise_for :users

  resources :messages


  root to: 'index#home'

  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get "conversation" => 'messages#conversation'


  get '/general' => 'index#general'
  get '/research' => 'index#research'

 
end
