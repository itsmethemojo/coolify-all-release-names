# frozen_string_literal: true

require 'test_helper'

class NamePoolsModelTest < ActiveSupport::TestCase
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
end
