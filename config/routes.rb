Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    root 'pages#home'
    get 'about', to: 'pages#about'
    get 'signup', to: 'users#new'
    resources :users, except: [:new]
    resources :articles
  end
end
