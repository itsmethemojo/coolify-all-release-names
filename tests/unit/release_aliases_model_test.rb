# frozen_string_literal: true

require 'mock_redis'
require 'test/unit'
require_relative '../../src/models/name_pools_model.rb'
require_relative '../../src/models/release_aliases_model.rb'

# test suite to test ReleaseAliasesModel
class ReleaseAliasesModelTest < Test::Unit::TestCase
  STATIC_ROOT = '/tmp/tests/static'

  def test_release_aliases_empty
    release_aliases = init_release_aliases
    assert(
      release_aliases.index('1', 'unit-tests').empty?,
      'new release is empty'
    )
  end

  def test_release_aliases_create_item_twice
    release_aliases = init_release_aliases
    t1 = release_aliases.create('1', 'unit-tests', '1.0.0')
    assert(t1.key?('1.0.0'), 'return key value if item is created')
    t2 = release_aliases.create('1', 'unit-tests', '1.0.0')
    assert(t2.key?('1.0.0'), 'return key value if item is created')
    assert(
      t1 == t2,
      'the release alias created on the second call is identic'
    )
  end

  def test_release_aliases_create_multiple_items
    release_aliases = init_release_aliases
    t1 = release_aliases.create('1', 'unit-tests', '1.0.0')
    assert(t1.key?('1.0.0'), 'return key value if item is created')
    t2 = release_aliases.create('1', 'unit-tests', '2.0.0')
    assert(t2.key?('2.0.0'), 'return key value if item is created')
    t3 = release_aliases.create('1', 'unit-tests', '3.0.0')
    assert(t3.key?('3.0.0'), 'return key value if item is created')
  end

  def test_release_aliases_length_after_multiple_creates
    release_aliases = init_release_aliases_with_three_items
    t1 = release_aliases.index('1', 'unit-tests')
    assert(t1.keys.length == 3, '3 items in index list')
  end

  def test_release_aliases_index_keys_after_multiple_creates
    release_aliases = init_release_aliases_with_three_items
    t1 = release_aliases.index('1', 'unit-tests')
    assert(t1.key?('1.0.0'), '1.0.0 in keys')
    assert(t1.key?('2.0.0'), '2.0.0 in keys')
    assert(t1.key?('3.0.0'), '3.0.0 in keys')
  end

  def test_release_aliases_index_values_after_multiple_creates
    release_aliases = init_release_aliases_with_three_items
    t1 = release_aliases.index('1', 'unit-tests')
    assert(t1.invert.key?('one'), 'one in values')
    assert(t1.invert.key?('two'), 'two in values')
    assert(t1.invert.key?('three'), 'three in values')
  end

  def test_release_aliases_full
    release_aliases = init_release_aliases_with_three_items
    assert_raise(
      NoReleaseNamesLeftException,
      'ReleaseNameModel create throws exception if no release name left '\
      'in the source list to take'
    ) do
      release_aliases.create('1', 'unit-tests', '4.0.0')
    end
  end

  private

  def init_release_aliases
    name_lists = NamePoolsModel.new(static_root)
    ReleaseAliasesModel.new(name_lists, MockRedis.new)
  end

  def init_release_aliases_with_three_items
    release_aliases = init_release_aliases
    release_aliases.create('1', 'unit-tests', '1.0.0')
    release_aliases.create('1', 'unit-tests', '2.0.0')
    release_aliases.create('1', 'unit-tests', '3.0.0')
    release_aliases
  end

  def prepare_static_test_files
    write_file(
      static_root,
      'namepools.json',
      '[{"id":"1","name":"one"},{"id":"2","name":"two"}]'
    )
    write_file(static_root + '/namepools', '1.json', '["one","two","three"]')
    write_file(static_root + '/namepools', '2.json', '["four","five","six"]')
  end

  def write_file(folderpath, filename, content)
    FileUtils.mkdir_p(folderpath) unless File.directory?(folderpath)
    file = File.new(folderpath + '/' + filename, 'w')
    file.write(content)
    file.close
  end

  def remove_dir(path)
    FileUtils.rm_rf(path)
  end

  def static_root
    STATIC_ROOT
  end

  def setup
    prepare_static_test_files
  end

  def teardown
    remove_dir(static_root)
  end
end
