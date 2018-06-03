Rails.application.routes.draw do
  get 'api/namelists' => 'namelists#index'
  get 'api/namelists/:name_list_id' => 'namelists#item'
  get 'api/namelists/:name_list_id/project/:project_name' => 'releasenames#index'
  post 'api/namelists/:name_list_id/project/:project_name' => 'releasenames#create'
end
