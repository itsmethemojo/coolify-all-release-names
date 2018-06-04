# frozen_string_literal: true

require 'test_helper'

class ReleaseAliasesModelTest < ActiveSupport::TestCase
  def test_release_aliases_empty
    release_aliases = init_release_aliases
    assert_raise(
      NoSuchEntityException,
      'ReleaseNameModel index throws exception if no release alias '\
      'for that project was ever created'
    ) do
      puts release_aliases.index('1', 'unit-tests')
      release_aliases.index('1', 'unit-tests')
    end
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
    ReleaseAliasesModel.new(dynamic_root, name_lists)
  end

  def init_release_aliases_with_three_items
    release_aliases = init_release_aliases
    release_aliases.create('1', 'unit-tests', '1.0.0')
    release_aliases.create('1', 'unit-tests', '2.0.0')
    release_aliases.create('1', 'unit-tests', '3.0.0')
    release_aliases
  end
end
