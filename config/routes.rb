Rails.application.routes.draw do
  root 'cards#index'
  resources :cards do
    collection do
      post 'import'
      post 'confirm'
    end
  end
end
