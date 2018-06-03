class ReleasenamesController < ApplicationController
  def index
    index = ReleasenamesModel.new.index(params[:namelist_id], params[:project_name])
    render json: index
  rescue NoSuchEntityException
    renderErrorResponse(404)
  end

  def create
    item = ReleasenamesModel.new.create(params[:namelist_id], params[:project_name], params[:release_name])
    render json: item
  rescue NoReleaseNamesLeftException
    renderErrorResponse(400, 'no release names left')
  end
end
