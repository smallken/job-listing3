Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :jobs do
      member do
        post :publish
        post :hide
      end

      resources :resumes
    end
  end

  resources :jobs do
    resources :resumes
    collection do
      get :search 
    end
  end

  root 'welcome#index'
end
