Stevegrossi::Application.routes.draw do

  namespace :meta do
    resources :books, :authors, :works, :writings
    root to: 'dashboard#home', as: :dashboard
  end

  get '/wishlist' => redirect('http://amzn.com/w/156EDXYQR8J2F')
  get '/made' => redirect('/built')
  get '/made/:slug' => redirect("/built/%{slug}")
  get '/resume' => redirect("/is/forhire")

  resources :users
  resources :books, path: 'read', only: [:index, :show] do
    collection do
      resources :authors, only: [:index, :show]
      get 'about' => 'books#topics', as: :topics
      get 'about/:topic' => 'books#topic', as: :tagged
    end
  end
  resources :writings, path: 'wrote', only: [:index, :show]
  resources :works, path: 'built', only: [:index, :show]

  resources :sessions, only: [:new, :create, :destroy]
  get 'log_in' => 'sessions#new', as: 'log_in'
  post 'log_in' => 'sessions#create', as: 'log_in'
  get 'log_out' => 'sessions#destroy', as: 'log_out'
  get 'is' => 'static_pages#about', as: 'about'
  get 'is/forhire' => 'static_pages#resume', as: 'resume'
  get 'styleguide' => 'static_pages#styleguide'
  get 'colophon' => 'static_pages#colophon'
  get 'search' => 'static_pages#search'
  get 'feed' => 'static_pages#feed', format: :rss

  root to: "static_pages#home"

  # 404 if route not recognized
  match '*a', to: 'static_pages#error_404'

end
