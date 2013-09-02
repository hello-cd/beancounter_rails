Beancounter::Application.routes.draw do
  match "/users" => "users#show", as:"user"
  match "/users/facebook/publish" => "users#facebook_publish", as:"user_facebook_publish"
  match "/users/twitter/publish" => "users#twitter_publish", as:"user_twitter_publish"
  match 'auth', to: 'sessions#create'
  match 'sign_in', to: 'sessions#new', as: 'sign_in'
  match 'sign_out', to: 'sessions#destroy', as: 'sign_out'
  match '/admin', to: redirect('/admin/login')
  match '/admin/:id/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'
  match '/admin/customers_dashboard', to: 'admin#customers_dashboard', as: 'admin_customers_dashboard'
  match '/admin/auth', to: 'admin#auth'
  match '/admin/error', to: 'admin#error'
  match '/admin/login', to: 'admin#login'
  match '/admin/logout', to: 'admin#logout'
  root :to => redirect('/sign_in')
end
