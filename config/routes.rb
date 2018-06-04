Rails.application.routes.draw do
  get 'api/namepools' => 'namepools#index'
  get 'api/namepools/:name_list_id' => 'namepools#item'
  get 'api/namepools/:name_list_id/project/:project_name' => 'releasealiases#index'
  post 'api/namepools/:name_list_id/project/:project_name' => 'releasealiases#create'
end
