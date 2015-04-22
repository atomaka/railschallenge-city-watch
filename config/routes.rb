Rails.application.routes.draw do
  resources :emergencies, except: [:new, :edit, :destroy]
  resources :responders, except: [:new, :edit, :destroy]

  match '*path', to: 'errors#catch_404', via: :all
end
