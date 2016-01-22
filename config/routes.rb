Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  root 'rooms#index'


  resources :rooms, only: [:index, :show, :create] do
    post :access, on: :member
  end
end
