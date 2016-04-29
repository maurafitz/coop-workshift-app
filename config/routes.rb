Rails.application.routes.draw do

  resources :shifts
  resources :metashifts

  root to: 'signoffs#new'

  get '/users/get_all' => 'users#get_all', as: 'get_all_users'

  resources :users do
    collection { post :import }
  end
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  #get  'auth/failure' => 'sessions#failure'

  # get '/signup' => 'users#new'
  post '/users' => 'users#create'
  post '/users/upload' => 'users#upload', as: 'csv_upload'
  post '/users/add' => 'users#add_user', as: 'add_user'
  post '/users/confirm' => 'users#confirm_users', as: 'confirm_users'
  get '/users/:id' => 'users#profile', as: 'user_profile'
  get '/users/:id/edit' => 'users#edit_profile', as: 'edit_profile'
  post '/users/:id/edit/email' => 'users#edit_email', as: 'edit_email'
  post '/users/:id/edit/password' => 'users#edit_password', as: 'edit_password'
  #post '/users/:id/edit/permissions' => 'users#edit_permissions', as: 'edit_permissions'
  post '/users/:id/edit/admin_edit_user_info' => 'users#admin_edit_user_info', as: 'admin_edit_user_info'
  patch '/users/:id/edit_avatar' => 'users#upload_avatar', as: 'edit_avatar'
  get '/users/:id/pref/new' => 'users#new_preferences', as: 'new_preferences'
  #get '/preference_access' => 'users#preference_access', as: 'preference_access'

  post '/users/:id/pref/new' => 'users#create_pref_and_avail', as: 'create_pref'
  get '/users/:id/pref/edit' => 'users#edit_preferences', as: 'edit_preferences'
  post '/users/:id/pref/edit' => 'users#update_pref_and_avail', as: 'update_pref'
  get '/users/:id/admin_view_user' => 'users#admin_view_user', as: 'admin_view_user'

  post '/preferences/:id/toggle' => 'preferences#toggle', as: 'toggle_preferences'
  post '/preferences/toggle_all' => 'preferences#toggle_all', as: 'toggle_preferences_all'

  post '/metashifts/upload' => 'metashifts#upload', as: 'upload_metashifts'
  post '/metashifts/create' => 'metashifts#create_metashift', as: 'create_metashift'
  get '/workshifts/:id/new_timeslots' => 'workshifts#new_timeslots', as: 'new_timeslots'
  post '/workshifts/create_timeslots' => 'workshifts#create_timeslots', as: 'create_timeslots'
  put '/workshifts/:id/change_users' => 'workshifts#change_users', as: 'change_workshift_users'
  resources :workshifts
  get '/assignments' => 'assignments#new', as: 'new_assignments'
  post 'assignments/create' => 'assignments#create', as: 'create_assignments'
  get '/assignments/:id/sort_users' => 'assignments#sort_users', as: 'sort_users'
  
  put '/shifts/:id/change_users' => 'shifts#change_users', as: 'change_shift_user'
  
  get '/index' => 'workshift#index'
  
  get '/policies/new' => 'policies#new', as: 'new_policy'
  get '/policies/edit' => 'policies#edit', as: 'edit_policy'
  get '/policies/' => 'policies#show', as: 'policy'
  post 'policies/' => 'policies#create'
  put '/policies/' => 'policies#update'
  
  get '/' => 'signoffs#new', as: 'signoff_page'
  post '/signoffs/submit' => 'signoffs#submit', as: "submit_signoff"
  
  get '/signoffs/set_unit' => 'signoffs#get_unit', as: "get_unit"
  post '/signoffs/set_unit' => 'signoffs#set_unit', as: "set_unit"
  get '/signoffs/:id/get_shifts' => 'signoffs#get_shifts'
  get '/signoffs/get_all_shifts' => 'signoffs#get_all_shifts'
  get '/signoffs/submit' => 'signoffs#submit'
  get '/signoffs/email_admin' => 'signoffs#email_admin', as: 'email_admin'


end