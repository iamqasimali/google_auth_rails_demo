Rails.application.routes.draw do


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")

  devise_for :users, :controllers => { sessions: 'users/sessions'}

  root "home#index"

  resources :home, only: %[index] do
    collection do
      get :settings
      get :profile
    end
  end

  resources :two_factor_settings, only: %[new] do
    collection do
      post :verify_otp
      get :otp_code
    end
  end
end
