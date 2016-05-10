Rails.application.routes.draw do
  root 'decks#index'

  resources :decks, except: [:show] do
    resources :cards, only: [:index]
    collection do
      get 'search'
    end
  end

  resources :cards, except: [:index] do
    collection do
      post 'import'
      post 'confirm'
    end
  end
end
