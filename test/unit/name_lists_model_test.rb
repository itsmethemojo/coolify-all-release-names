# frozen_string_literal: true

require 'test_helper'

class NameListsModelTest < ActiveSupport::TestCase
  def test_name_lists_index
    prepare_static_test_files(@@staticFilesRoot)
    item_list = NameListsModel.new(@@staticFilesRoot).index
    assert(
      item_list.is_a?(Array),
      'NameListsModel index returns array'
    )
    assert(
      item_list.sample.key?('id'),
      'random NameListsModel item has id key'
    )
    assert(
      item_list.sample.key?('name'),
      'random NameListsModel item has name key'
    )
    remove_dir(@@staticFilesRoot)
  end

  def test_name_lists_item
    prepare_static_test_files(@@staticFilesRoot)
    item1 = NameListsModel.new(@@staticFilesRoot).item('1')
    assert(
      item1 == %w[one two three],
      'NameListsModel item "1" returns array'
    )
    item2 = NameListsModel.new(@@staticFilesRoot).item('2')
    assert(
      item2 == %w[four five six],
      'NameListsModel item "2" returns array'
    )
    remove_dir(@@staticFilesRoot)
  end
end
