Rails.application.routes.draw do
  resources :doctors, only: [:show] do
    resources :doctor_patients, only: [:destroy]
  end
  resources :patients, only: [:index]
  resources :hospitals, only: [:show]
end
