Rails.application.routes.draw do
  devise_for :users, path: "admin", path_names: { sign_in: "login", sign_out: "logout" }, skip: [ :registrations ]

  namespace :admin do
    root to: "dashboard#show"
    resources :categories
    resources :products
    resources :addons
    resources :business_hours, only: [ :index, :update ]
    resource :settings, only: [ :show, :update ]
    post "store/toggle", to: "store#toggle", as: :store_toggle
  end

  scope path: "r/:restaurant_slug", as: "storefront" do
    get "/", to: "storefront/menus#show", as: :menu
    get "/products/:id", to: "storefront/products#show", as: :product
    get "/cart", to: "storefront/carts#show", as: :cart
    post "/cart/items", to: "storefront/cart_items#create", as: :cart_items
    patch "/cart/items/:id", to: "storefront/cart_items#update", as: :cart_item
    delete "/cart/items/:id", to: "storefront/cart_items#destroy", as: :destroy_cart_item
    get "/checkout", to: "storefront/checkouts#show", as: :checkout
    post "/orders", to: "storefront/orders#create", as: :orders
    get "/order/:id", to: "storefront/orders#show", as: :order
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect("/admin/login")
end
 
