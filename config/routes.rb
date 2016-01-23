Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root 'rooms#index'

  resources :rooms, only: [:index, :show, :create] do
    post :access, on: :member
  end
end
