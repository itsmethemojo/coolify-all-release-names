Rails.application.routes.draw do
  get 'api/bundles' => 'bundles#index'
end
