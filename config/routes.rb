Rails.application.routes.draw do

  root 'users#login'

  get 'users/availability'
  post 'users/availability', to: 'users#availability_post'
  get 'users/profile'

  get 'users/subboard'
  get 'users/subboard_remove/:tour_id', to: 'users#subboard_remove'
  get 'users/subboard_claim/:tour_id', to: 'users#subboard_claim'
  get 'users/points'
  get 'users/check_in'
  post 'users/check_in', to: 'users#check_in_post'
  get 'users/list', to: 'users#list'
  get 'users/reset_points', to: 'users#reset_points'
  get 'users/:id', to: 'users#delete'
  get 'users/make_admin/:id', to: 'users#make_admin'
  get 'users/revoke_admin/:id', to: 'users#revoke_admin'
  get 'users/manual_check_in/:user_id/:tour_id', to: 'users#manual_check_in'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'users#login'
  post 'login', to: 'users#login_submit'
  get 'logout', to: 'users#logout'

  get 'tours/new'
  post 'tours/create'
  get 'tours/manage'
  get 'tours/delete_all', to: 'tours#delete_all'
  get 'tours/scheduler', to: 'tours#scheduler'
  post 'tours/scheduler', to: 'tours#scheduler_post'
  get 'tours/:id', to: 'tours#delete'
  get 'tours/manage/:id', to: 'tours#manage_guides'
  get 'tours/remove_guide/:tour_id/:user_id', to: 'tours#remove_guide'
  get 'tours/add_guide/:tour_id/:user_id', to: 'tours#add_guide'
  get 'tours/view_guides/:id', to: 'tours#view_guides'
  patch 'tours/change_location/:id', to: 'tours#change_location'
  patch 'tours/change_notes/:id', to: 'tours#change_notes'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
