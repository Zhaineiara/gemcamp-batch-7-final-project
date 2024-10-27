Rails.application.routes.draw do
  devise_for :users

  authenticated :user, ->(u) { u.admin? } do
    root 'home#admin', as: :admin_root
  end

  authenticated :user, ->(u) { u.client? } do
    root 'home#client', as: :client_root
  end

  unauthenticated do
    root 'home#index'
  end
end