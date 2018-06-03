Rails.application.routes.draw do
  get 'api/namelists' => 'namelists#index'
  get 'api/namelists/:namelist_id' => 'namelists#item'
  get 'api/namelists/:namelist_id/project/:project_name' => 'releasenames#index'
  post 'api/namelists/:namelist_id/project/:project_name' => 'releasenames#create'
end
