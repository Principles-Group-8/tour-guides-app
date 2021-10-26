Rails.application.routes.draw do

  root 'static#index'

  get 'users/availability'
  post 'users/availability', to: 'users#availability_post'
  get 'users/profile'
  get 'users/points'
  get 'users/check_in'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'users#login'
  post 'login', to: 'users#login_submit'
  get 'logout', to: 'users#logout'

  get 'list', to: 'users#list'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
