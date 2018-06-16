# frozen_string_literal: true

require 'test/unit'
require_relative '../../src/models/name_pools_model.rb'

# test suite to test NamePoolsModel
class NamePoolsModelTest < Test::Unit::TestCase
  STATIC_ROOT = '/tmp/tests/static'
  DYNAMIC_ROOT = '/tmp/tests/dynamic'

  def test_name_pools_index
    item_list = NamePoolsModel.new(static_root).index
    assert(item_list.is_a?(Array), 'index returns list')
    assert(item_list.sample.key?('id'), 'item from list has key "id"')
    assert(item_list.sample.key?('name'), 'item from list has key "name"')
  end

  def test_name_pools_1
    item1 = NamePoolsModel.new(static_root).item('1')
    assert(
      item1 == %w[one two three],
      'NamePoolsModel item "1" returns array'
    )
  end

  def test_name_pools_2
    item2 = NamePoolsModel.new(static_root).item('2')
    assert(
      item2 == %w[four five six],
      'NamePoolsModel item "2" returns array'
    )
  end

  private

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

  def dynamic_root
    DYNAMIC_ROOT
  end

  def setup
    prepare_static_test_files
  end

  def teardown
    remove_dir(static_root)
    remove_dir(dynamic_root)
  end
end
