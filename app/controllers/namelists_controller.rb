class NamelistsController < ApplicationController
  def index
    render json: NamelistsModel.new.index
  end

  def item
    item = NamelistsModel.new.item(params[:namelist_id])
    render json: item
  rescue NoSuchEntityException
    renderErrorResponse(404)
  end
end
