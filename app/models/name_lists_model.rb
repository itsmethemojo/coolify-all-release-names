require 'json'

class NameListsModel
  include ActiveModel::Model

  @filesRoot

  def initialize(filesRoot = 'storage')
    @filesRoot = filesRoot
  end

  def index
    JSON.parse(File.read Rails.root.join(@filesRoot, 'namelists.json'))
  end

  def item(id)
    filename = Rails.root.join(@filesRoot, 'namelists', id + '.json')
    if !File.exist?(filename)
      raise NoSuchEntityException
    end
    JSON.parse(File.read filename)
  end
end
