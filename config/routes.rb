ActionController::Routing::Routes.draw do |map|
  map.resources :profiles
  map.resources :issues
  map.resources :users
  map.resource :session
  map.resources :movies
  map.resources :posts

  map.activate  '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup    '/signup', :controller => 'users', :action => 'new'
  map.login     '/login', :controller => 'sessions', :action => 'new'
  map.logout    '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot    '/forgot', :controller => 'users', :action => 'forgot'
  map.reset     'reset/:reset_code', :controller => 'users', :action => 'reset'
  map.root :controller => "sessions", :action => "new"
  
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
