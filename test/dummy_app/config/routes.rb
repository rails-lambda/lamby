Dummy::Application.routes.draw do
  root to: 'application#index'
  get 'image' => 'application#image'
  post 'login', to: 'application#login'
  delete 'logout', to: 'application#logout'
  get 'exception', to: 'application#exception'
  get 'cooks', to: 'application#cooks'
  get 'redirect_test', to: redirect('/')
end
