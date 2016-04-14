Rails.application.routes.draw do


  resources :shifts
  resources :metashifts
  root to: 'shifts#index'
  get '/users/get_all' => 'users#get_all', as: 'get_all_users'

  resources :users do
    collection { post :import }
  end
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  #get  'auth/failure' => 'sessions#failure'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  post '/users/confirm' => 'users#confirm_users', as: 'confirm_users'
  post '/users/upload' => 'users#upload', as: 'csv_upload'
  post '/users/add' => 'users#add_user', as: 'add_user'
  get '/users/:id' => 'users#profile', as: 'user_profile'
  post '/users/:id/edit' => 'users#edit_profile', as: 'edit_profile'
  patch '/users/:id/edit_avatar' => 'users#upload_avatar', as: 'edit_avatar'
  get '/users/:id/pref/new' => 'users#new_preferences', as: 'new_preferences'
  post '/users/:id/pref' => 'users#set_preferences', as: 'post_pref_page'
  post '/users/:id/avail' => 'users#set_availability', as: 'post_avail_page'
  


  get '/index' => 'workshift#index'
  post '/shifts/new' => 'shifts#new', as: 'create_shifts'
  post '/metashifts/add' => 'metashifts#add_metashift', as: 'add_metashift'
  post '/shifts/upload' => 'metashifts#upload', as: 'shift_csv_upload'
  get '/shifts/:id/new_timeslots' => 'shifts#new_timeslots', as: 'new_timeslots'
  post '/shifts/add_timeslots' => 'shifts#add_timeslots', as: 'add_timeslots'
  
  
  get '/policies/new' => 'policies#new', as: 'new_policy'
  get '/policies/edit' => 'policies#edit', as: 'edit_policy'
  get '/policies/' => 'policies#show', as: 'policy'
  post 'policies/' => 'policies#create'
  put '/policies/' => 'policies#update'
  
  
end