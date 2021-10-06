Rails.application.routes.draw do

  root 'static#index'

  get 'users/availability'
  get 'users/profile'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'users#login'
  post 'login', to: 'users#login_submit'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
