# frozen_string_literal: true

require 'json'
require 'sinatra'

set :root, File.absolute_path(__dir__ + '/..')
settings_public = proc { File.join(root, 'public') }
set :public_folder, settings_public
settings_model_path = proc { File.join(root, 'src', 'models') + '/' }
set :model_path, settings_model_path
set :show_exceptions, !settings.production?
set :swagger_host, 'localhost:3000'
set :swagger_scheme, 'http'
unless settings.production?
  set :swagger_host, 'localhost:3000'
  set :swagger_scheme, 'http'
end

get '/api/namepools' do
  require_relative settings.model_path + 'name_pools_model.rb'
  body JSON.generate(NamePoolsModel.new.index)
end

get '/api/namepool/:name_pool_id' do
  require_relative settings.model_path + 'name_pools_model.rb'
  body JSON.generate(NamePoolsModel.new.item(params['name_pool_id']))
rescue NoSuchEntityException
  status 404
end

get '/api/namepool/:name_pool_id/project/:project_name/releasealiases' do
  require_relative settings.model_path + 'release_aliases_model.rb'
  list = ReleaseAliasesModel.new.index(
    params['name_pool_id'],
    params['project_name']
  )
  body JSON.generate(list)
end

post '/api/namepool/:name_pool_id/project/:project_name/releasealiases' do
  require_relative settings.model_path + 'release_aliases_model.rb'
  item = ReleaseAliasesModel.new.create(
    params['name_pool_id'],
    params['project_name'],
    params['release_name']
  )
  status 201
  body JSON.generate(item)
rescue NoReleaseNamesLeftException
  status 400
  body JSON.generate(
    status: 400,
    message: 'No Release Names Left'
  )
end

get '/swagger.json' do
  erb :'templates/swagger.json',
      content_type: :'application/json',
      locals: {
        host: request.env['HTTP_HOST'],
        scheme: request.env['REQUEST_URI'].split(':').first
      }
end

not_found do
  body JSON.generate(
    status: 404,
    message: 'Not Found'
  )
end

error do
  status 500
  body JSON.generate(
    status: 500,
    message: 'Internal Server Error'
  )
end

after do
  puts body
end
