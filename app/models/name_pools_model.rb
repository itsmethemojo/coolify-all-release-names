# frozen_string_literal: true

require 'json'

# model to access name pools from file system
class NamePoolsModel
  include ActiveModel::Model

  @files_root = nil

  def initialize(files_root = 'storage')
    @files_root = files_root
  end

  def index
    JSON.parse(File.read(Rails.root.join(@files_root, 'namelists.json')))
  end

  def item(id)
    filename = Rails.root.join(@files_root, 'namelists', id + '.json')
    raise NoSuchEntityException unless File.exist?(filename)
    JSON.parse(File.read(filename))
  end
end
