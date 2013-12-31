require 'resque/server'

Feddit::Application.routes.draw do
  root :to => 'users#new'

  resources :users do
    member do
      get :activate
      get :deactivate
    end
  end

  mount Resque::Server, :at => "/resque"

  Resque::Server.use(Rack::Auth::Basic) do |user, password|
    password == "secret"
  end
end
