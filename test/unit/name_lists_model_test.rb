# frozen_string_literal: true

require 'test_helper'

class NamePoolsModelTest < ActiveSupport::TestCase
  def test_name_lists_index
    prepare_static_test_files
    item_list = NamePoolsModel.new(static_root).index
    assert(
      item_list.is_a?(Array),
      'NamePoolsModel index returns array'
    )
    assert(
      item_list.sample.key?('id'),
      'random NamePoolsModel item has id key'
    )
    assert(
      item_list.sample.key?('name'),
      'random NamePoolsModel item has name key'
    )
    remove_dir(static_root)
  end

  def test_name_lists_item
    prepare_static_test_files
    item1 = NamePoolsModel.new(static_root).item('1')
    assert(
      item1 == %w[one two three],
      'NamePoolsModel item "1" returns array'
    )
    item2 = NamePoolsModel.new(static_root).item('2')
    assert(
      item2 == %w[four five six],
      'NamePoolsModel item "2" returns array'
    )
    remove_dir(static_root)
  end
end
