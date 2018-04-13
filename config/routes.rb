Rails.application.routes.draw do
  resources :ruby_gems, only: [:index, :show]

  root 'ruby_gems#index'
end
