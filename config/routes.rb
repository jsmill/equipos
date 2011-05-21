Equipos::Application.routes.draw do
  #get "entregas/index"
  resources :entregas
  resources :articulos 
  root :to => 'articulos#index'

end
