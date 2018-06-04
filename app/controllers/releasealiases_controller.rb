# frozen_string_literal: true

# controller to access a list of all created release aliases
# for a selected project from a selected name pool
# or to create new release aliases
class ReleasealiasesController < ApplicationController
  def index
    index = ReleaseAliasesModel.new.index(
      params[:name_list_id],
      params[:project_name]
    )
    render json: index
  rescue NoSuchEntityException
    render_error_response(404)
  end

  def create
    item = ReleaseAliasesModel.new.create(
      params[:name_list_id],
      params[:project_name],
      params[:release_name]
    )
    render json: item
  rescue NoReleaseNamesLeftException
    render_error_response(400, 'no release names left')
  end
end
