Rails.application.routes.draw do
  devise_for :users

  constraints(ClientDomainConstraint.new) do
    authenticated :user, ->(u) { u.client? } do
      root 'home#client', as: :client_root
    end
  end

  constraints(AdminDomainConstraint.new) do
    authenticated :user, ->(u) { u.admin? } do
      root 'home#admin', as: :admin_root
    end
  end

  root 'home#index'
end