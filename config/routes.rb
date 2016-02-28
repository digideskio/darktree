Rails.application.routes.draw do
  root 'cards#index'
  resources :cards do
    member do
      put 'fav'
    end
    collection do
      post 'import'
      post 'confirm'
    end
  end
end
