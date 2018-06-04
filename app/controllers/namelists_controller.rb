# frozen_string_literal: true

class NamelistsController < ApplicationController
  def index
    render json: NameListsModel.new.index
  end

  def item
    item = NameListsModel.new.item(params[:name_list_id])
    render json: item
  rescue NoSuchEntityException
    renderErrorResponse(404)
  end
end
