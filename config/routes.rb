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

  get "/user", to: "user#index"
  post "/user", to: "user#create"
  get "/user/:id", to: "user#show"
  put "/user/:id", to: "user#update"
  delete "/user/:id", to: "user#destroy"

  get "/current", to: "login_session#current"
  post "/login", to: "login_session#login"
  post "/logout", to: "login_session#logout"
end
