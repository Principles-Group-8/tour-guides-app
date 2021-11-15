Rails.application.routes.draw do

  root 'users#login'

  get 'users/availability'
  post 'users/availability', to: 'users#availability_post'
  get 'users/profile'

  get 'users/subboard'
  post 'subboard_remove', to: 'users#subboard_remove'
  post 'subboard_claim', to: 'users#subboard_claim'
  get 'users/points'
  get 'users/check_in'
  post 'users/check_in', to: 'users#check_in_post'
  get 'users/list', to: 'users#list'
  get 'users/:id', to: 'users#delete'
  get 'users/make_admin/:id', to: 'users#make_admin'
  get 'users/revoke_admin/:id', to: 'users#revoke_admin'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'users#login'
  post 'login', to: 'users#login_submit'
  get 'logout', to: 'users#logout'

  get 'tours/new'
  post 'tours/create'
  get 'tours/manage'
  get 'tours/:id', to: 'tours#delete'
  get 'tours/manage/:id', to: 'tours#manage_guides'
  post 'remove_guide', to: 'tours#remove_guide'
  post 'add_guide', to: 'tours#add_guide'
  get 'tours/view_guides/:id', to: 'tours#view_guides'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
