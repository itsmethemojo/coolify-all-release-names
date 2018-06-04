# frozen_string_literal: true

require 'json'
require 'fileutils'

# model to access already created release aliases and to create new ones
class ReleaseAliasesModel
  include ActiveModel::Model

  @files_root = nil
  @name_lists = nil

  def initialize(files_root = 'tmp', name_lists = NamePoolsModel.new)
    @files_root = files_root
    @name_lists = name_lists
  end

  def index(name_list_id, project_name)
    filename = get_filename(name_list_id, project_name)
    raise NoSuchEntityException unless File.exist?(filename)
    JSON.parse(File.read(filename))
  end

  def create(name_list_id, project_name, release_name)
    release_aliases = get_release_aliases(name_list_id, project_name)
    if release_aliases[release_name].nil?
      release_aliases[release_name] = generate_release_alias(
        name_list_id,
        release_aliases.values
      )
      put_release_aliases(name_list_id, project_name, release_aliases)
    end
    { release_name => release_aliases[release_name] }
  end

  private

  def get_filename(name_list_id, project_name)
    Rails.root.join(@files_root, name_list_id, project_name + '.json')
  end

  def get_foldername(name_list_id)
    Rails.root.join(@files_root, name_list_id)
  end

  def write_file(filename, content)
    file = File.new(filename, 'w')
    file.write(content)
    file.close
  end

  def get_release_aliases(name_list_id, project_name)
    filename = get_filename(name_list_id, project_name)
    unless File.exist?(filename)
      FileUtils.mkdir_p(get_foldername(name_list_id))
      write_file(filename, '{}')
    end
    JSON.parse(File.read(filename))
  end

  def put_release_aliases(name_list_id, project_name, data)
    filename = get_filename(name_list_id, project_name)
    write_file(filename, JSON.generate(data))
  end

  def generate_release_alias(name_list_id, already_used_aliases)
    left_names = @name_lists.item(name_list_id) - already_used_aliases
    raise NoReleaseNamesLeftException if left_names.empty?
    left_names.sample
  end
end
