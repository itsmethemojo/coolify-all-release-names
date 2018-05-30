#require 'json'

class BundlesController < ApplicationController
  def index
    render json: BundlesModel.new.list
  end
end
