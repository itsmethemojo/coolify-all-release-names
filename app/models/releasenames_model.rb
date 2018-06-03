require 'json'

class ReleasenamesModel
  include ActiveModel::Model

  def index(namelist_id, project_name)
    filename = getFilename(namelist_id, project_name)
    if !File.exist?(filename)
      raise NoSuchEntityException
    end
    JSON.parse(File.read filename)
  end

  def create(namelist_id, project_name, release_name)
    filename = getFilename(namelist_id, project_name)
    if !File.exist?(filename)
      Dir.mkdir(getFoldername(namelist_id))
      writeFile(filename,'{}')
    end
    releases = JSON.parse(File.read filename)
    if releases[release_name].nil?
      releases[release_name] = generateReleaseAlias(namelist_id,releases.values)
      writeFile(filename,JSON.generate(releases))
    end
    {release_name => releases[release_name]}
  end

  private

  def getFilename(namelist_id, project_name)
    Rails.root.join('tmp', namelist_id, project_name + '.json')
  end

  def getFoldername(namelist_id)
    Rails.root.join('tmp', namelist_id)
  end

  def writeFile(filename, content)
    file = File.new(filename,'w')
    file.write(content)
    file.close
  end

  def generateReleaseAlias(namelist_id, already_used_aliases)
    left_names = NamelistsModel.new.item(namelist_id) - already_used_aliases
    if left_names.empty?
      raise NoReleaseNamesLeftException.new
    end
    left_names.sample
  end
end
