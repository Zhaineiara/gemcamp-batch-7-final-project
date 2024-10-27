Rails.application.routes.draw do
  namespace :admin do
    get 'home/index'
  end
  namespace :client do
    get 'home/index'
  end
  devise_for :users

  constraints(ClientDomainConstraint.new) do
    authenticated :user, ->(u) { u.client? } do
      root 'client/home#index', as: :client_root
    end
  end

  constraints(AdminDomainConstraint.new) do
    authenticated :user, ->(u) { u.admin? } do
      root 'admin/home#index', as: :admin_root
    end
  end

  root 'home#index'
end