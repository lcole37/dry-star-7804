Rails.application.routes.draw do
  # resources :patients
  resources :doctors, only: [:show] do
    resources :doctor_patients, only: [:destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
