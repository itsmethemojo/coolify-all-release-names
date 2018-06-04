# frozen_string_literal: true

require 'test_helper'

class ReleaseNamesModelTest < ActiveSupport::TestCase
  def test_release_names_index_create
    prepare_static_test_files(@@static_files_root)
    name_lists = NameListsModel.new(@@static_files_root)
    release_names = ReleaseNamesModel.new(@@dynamic_files_root, name_lists)

    assert_raise(
      NoSuchEntityException,
      'ReleaseNameModel index throws exception if no release name '\
      'for that project was ever created'
    ) do
      release_names.index('1', 'unit-tests')
    end

    key_value_return1 = release_names.create('1', 'unit-tests', '1.0.0')
    assert(
      key_value_return1.key?('1.0.0'),
      'ReleaseNameModel return key value if item is created'
    )

    key_value_return2 = release_names.create('1', 'unit-tests', '2.0.0')
    assert(
      key_value_return2.key?('2.0.0'),
      'ReleaseNameModel return key value if item is created'
    )

    key_value_return3 = release_names.create('1', 'unit-tests', '3.0.0')
    assert(
      key_value_return3.key?('3.0.0'),
      'ReleaseNameModel return key value if item is created'
    )

    key_value_return4 = release_names.create('1', 'unit-tests', '3.0.0')
    assert(
      key_value_return4.key?('3.0.0'),
      'ReleaseNameModel return same key if release was already named'
    )

    release_names_index = release_names.index('1', 'unit-tests')

    assert(
      release_names_index.keys.length == 3,
      'ReleaseNameModel has key 1.0.0'
    )
    assert(
      release_names_index.key?('1.0.0'),
      'ReleaseNameModel has key 1.0.0'
    )
    assert(
      release_names_index.key?('2.0.0'),
      'ReleaseNameModel has key 2.0.0'
    )
    assert(
      release_names_index.key?('3.0.0'),
      'ReleaseNameModel has key 3.0.0'
    )

    assert(
      release_names_index.invert.key?('one'),
      'ReleaseNameModel has used the names one, two, three from the namelist 1'
    )
    assert(
      release_names_index.invert.key?('two'),
      'ReleaseNameModel has used the names one, two, three from the namelist 1'
    )
    assert(
      release_names_index.invert.key?('three'),
      'ReleaseNameModel has used the names one, two, three from the namelist 1'
    )

    assert_raise(
      NoReleaseNamesLeftException,
      'ReleaseNameModel create throws exception if no release name left '\
      'in the source list to take'
    ) do
      release_names.create('1', 'unit-tests', '4.0.0')
    end

    remove_dir(@@dynamic_files_root)
    remove_dir(@@static_files_root)
  end
end
