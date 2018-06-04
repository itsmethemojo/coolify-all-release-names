# frozen_string_literal: true

# controller ot access list of pools (index)
# or a selected pool (item) of potentiel release names
class NamepoolsController < ApplicationController
  def index
    render json: NamePoolsModel.new.index
  end

  def item
    item = NamePoolsModel.new.item(params[:name_list_id])
    render json: item
  rescue NoSuchEntityException
    render_error_response(404)
  end
end
