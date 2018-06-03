class NamelistsController < ApplicationController
  def index
    render json: NamelistsModel.new.index
  end

  def item
    item = NamelistsModel.new.item(params[:namelist_id])
    if item.nil?
      renderErrorResponse(404)
      return
    end
    render json: item
  end
end
