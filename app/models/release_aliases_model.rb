# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'redis'

# model to access already created release aliases and to create new ones
class ReleaseAliasesModel
  include ActiveModel::Model

  @name_lists = nil
  @redis = nil
  KEY_PREFIX = 'bla'

  def initialize(
    name_lists = NamePoolsModel.new,
    redis = Redis.new
  )
    @name_lists = name_lists
    @redis = redis
  end

  def index(name_list_id, project_name)
    get_release_aliases(name_list_id, project_name)
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
    redis_entry = @redis.get(redis_key(name_list_id, project_name))
    redis_entry = '{}' if redis_entry.nil?
    JSON.parse(redis_entry)
  end

  def put_release_aliases(name_list_id, project_name, data)
    @redis.set(redis_key(name_list_id, project_name), JSON.generate(data))
  end

  def redis_key(name_list_id, project_name)
    KEY_PREFIX + name_list_id + project_name
  end

  def generate_release_alias(name_list_id, already_used_aliases)
    left_names = @name_lists.item(name_list_id) - already_used_aliases
    raise NoReleaseNamesLeftException if left_names.empty?
    left_names.sample
  end
end
