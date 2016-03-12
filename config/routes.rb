Rails.application.routes.draw do
  root 'cards#index'
  resources :cards do
    member do
      put 'favorite' => 'cards#favorite'
      delete 'favorite' => 'cards#unfavorite'
    end
    collection do
      post 'import'
      post 'confirm'
    end
  end
end
