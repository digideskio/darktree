Rails.application.routes.draw do
  root 'decks#index'

  resources :decks, except: [:show] do
    resources :cards, only: [:index]
  end

  resources :cards, except: [:index] do
    collection do
      post 'import'
      post 'confirm'
    end
  end
end
