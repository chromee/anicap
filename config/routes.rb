Rails.application.routes.draw do
  resources :pictures
  root 'pictures#index'
  get 'static_pages/help'
  get 'static_pages/about'
end
