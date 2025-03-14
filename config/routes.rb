Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: [:create, :index] do
        collection do
          get 'ips', to: 'posts#ip_list'
        end
      end

      post 'rating', to: 'ratings#create'
    end
  end
end
