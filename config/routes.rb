Rails.application.routes.draw do
  root 'decks#index'

  resources :decks do
    resources :cards, only: [:index]
    collection do
      get 'search'
      post 'import'
    end
  end

  resources :deck_sources, except: [:show, :new, :edit]

  resources :cards do
    collection do
      post 'import'
      post 'confirm'
    end
  end
end
