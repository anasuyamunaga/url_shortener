Rails.application.routes.draw do
  root "links#index"

  resources :links, param: :slug, only: %i[index new create show]
  get "/r/:slug", to: "redirects#show", as: :redirect

  # Health check (Rails 8 default)
  get "up" => "rails/health#show", as: :rails_health_check
end
