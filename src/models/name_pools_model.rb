# frozen_string_literal: true

require 'json'
require_relative __dir__ + '/../exceptions/no_such_entity_exception.rb'

# model to access name pools from file system
class NamePoolsModel
  @files_root = nil

  def initialize(files_root = __dir__ + '/../../storage')
    @files_root = files_root
  end

  def index
    JSON.parse(File.read(@files_root + '/namelists.json'))
  end

  def item(id)
    filename = @files_root + '/namelists/' + id + '.json'
    raise NoSuchEntityException unless File.exist?(filename)
    JSON.parse(File.read(filename))
  end
end
