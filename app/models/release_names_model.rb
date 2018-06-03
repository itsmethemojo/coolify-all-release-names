require 'json'
require 'fileutils'

class ReleaseNamesModel
  include ActiveModel::Model

  @filesRoot
  @nameLists

  def initialize(filesRoot = 'tmp', nameLists = NameListsModel.new)
    @filesRoot = filesRoot
    @nameLists = nameLists
  end

  def index(name_list_id, project_name)
    filename = getFilename(name_list_id, project_name)
    if !File.exist?(filename)
      raise NoSuchEntityException
    end
    JSON.parse(File.read filename)
  end

  def create(name_list_id, project_name, release_name)
    filename = getFilename(name_list_id, project_name)
    if !File.exist?(filename)
      FileUtils.mkdir_p(getFoldername(name_list_id))
      writeFile(filename,'{}')
    end
    releases = JSON.parse(File.read filename)
    if releases[release_name].nil?
      releases[release_name] = generateReleaseAlias(name_list_id,releases.values)
      writeFile(filename,JSON.generate(releases))
    end
    {release_name => releases[release_name]}
  end

  private

  def getFilename(name_list_id, project_name)
    Rails.root.join(@filesRoot, name_list_id, project_name + '.json')
  end

  def getFoldername(name_list_id)
    Rails.root.join(@filesRoot, name_list_id)
  end

  def writeFile(filename, content)
    file = File.new(filename,'w')
    file.write(content)
    file.close
  end

  def generateReleaseAlias(name_list_id, already_used_aliases)
    left_names = @nameLists.item(name_list_id) - already_used_aliases
    if left_names.empty?
      raise NoReleaseNamesLeftException.new
    end
    left_names.sample
  end
end
