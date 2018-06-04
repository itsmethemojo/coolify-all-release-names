# frozen_string_literal: true

require 'test_helper'

class NameListsModelTest < ActiveSupport::TestCase
  def test_name_lists_index
    prepare_static_test_files(@@static_files_root)
    item_list = NameListsModel.new(@@static_files_root).index
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
    remove_dir(@@static_files_root)
  end

  def test_name_lists_item
    prepare_static_test_files(@@static_files_root)
    item1 = NameListsModel.new(@@static_files_root).item('1')
    assert(
      item1 == %w[one two three],
      'NameListsModel item "1" returns array'
    )
    item2 = NameListsModel.new(@@static_files_root).item('2')
    assert(
      item2 == %w[four five six],
      'NameListsModel item "2" returns array'
    )
    remove_dir(@@static_files_root)
  end
end
