Rails.application.routes.draw do
  root 'cards#index'
  resources :cards do
    member do
      put 'favorite' => 'cards#favorite'
      delete 'favorite' => 'cards#unfavorite'
      put 'status' => 'cards#status'
    end
    collection do
      post 'import'
      post 'confirm'
    end
  end
end
