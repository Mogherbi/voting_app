Rails.application.routes.draw do

  resources :answers
  root 'statics#main'

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  resources :events do
    resources :projects
    resources :questions
    resources :answers
  end

  get "/sign_in" => "clearance/sessions#new"
  delete "/sign_out" => "clearance/sessions#destroy"
  get "/sign_up" => "clearance/users#new"


  post 'start_voting' => 'statics#start_voting'

  match '*path' => redirect { |p, req| req.flash[:error] = "Please use the given passphrase to access the site"; '/' }, via: :get

end
