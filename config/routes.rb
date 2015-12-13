Rails.application.routes.draw do

  devise_for :users

  root to: 'index#home'
  get 'signup'  => 'users#new'
  get 'login'   => 'sessions#new'
  
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

 
end
