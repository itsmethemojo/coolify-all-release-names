# frozen_string_literal: true

require 'json'

class NameListsModel
  include ActiveModel::Model

  @filesRoot

  def initialize(filesRoot = 'storage')
    @filesRoot = filesRoot
  end

  def index
    JSON.parse(File.read(Rails.root.join(@filesRoot, 'namelists.json')))
  end

  def item(id)
    filename = Rails.root.join(@filesRoot, 'namelists', id + '.json')
    raise NoSuchEntityException unless File.exist?(filename)
    JSON.parse(File.read(filename))
  end
end
