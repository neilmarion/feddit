Feddit::Application.routes.draw do
  root :to => 'users#new'

  resources :users do
    member do
      get :activate
    end
  end
end
