Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/session", to: "time_session#index"
  post "/session/start", to: "time_session#start"
  post "/session/end", to: "time_session#end"
  get "/session/active", to: "time_session#active"
  get "/session/:id", to: "time_session#show"
  delete "/session/:id", to: "time_session#destroy"
end
