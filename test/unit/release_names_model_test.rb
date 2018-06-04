# frozen_string_literal: true

require 'test_helper'

class ReleaseNamesModelTest < ActiveSupport::TestCase
  def test_release_names_index_create
    prepare_static_test_files(@@staticFilesRoot)
    name_lists = NameListsModel.new(@@staticFilesRoot)
    release_names = ReleaseNamesModel.new(@@dynamicFilesRoot, name_lists)

    assert_raise(
      NoSuchEntityException,
      'ReleaseNameModel index throws exception if no release name for that project was ever created'
    ) do
      release_names.index('1', 'unit-tests')
    end

    keyValueReturn1 = release_names.create('1', 'unit-tests', '1.0.0')
    assert(
      keyValueReturn1.key?('1.0.0'),
      'ReleaseNameModel return key value if item is created'
    )

    keyValueReturn2 = release_names.create('1', 'unit-tests', '2.0.0')
    assert(
      keyValueReturn2.key?('2.0.0'),
      'ReleaseNameModel return key value if item is created'
    )

    keyValueReturn3 = release_names.create('1', 'unit-tests', '3.0.0')
    assert(
      keyValueReturn3.key?('3.0.0'),
      'ReleaseNameModel return key value if item is created'
    )

    keyValueReturn4 = release_names.create('1', 'unit-tests', '3.0.0')
    assert(
      keyValueReturn4.key?('3.0.0'),
      'ReleaseNameModel return same key if release was already named'
    )

    releaseNames = release_names.index('1', 'unit-tests')

    assert(
      releaseNames.keys.length == 3,
      'ReleaseNameModel has key 1.0.0'
    )
    assert(
      releaseNames.key?('1.0.0'),
      'ReleaseNameModel has key 1.0.0'
    )
    assert(
      releaseNames.key?('2.0.0'),
      'ReleaseNameModel has key 2.0.0'
    )
    assert(
      releaseNames.key?('3.0.0'),
      'ReleaseNameModel has key 3.0.0'
    )

    assert(
      releaseNames.invert.key?('one'),
      'ReleaseNameModel has used the names one, two, three from the namelist 1'
    )
    assert(
      releaseNames.invert.key?('two'),
      'ReleaseNameModel has used the names one, two, three from the namelist 1'
    )
    assert(
      releaseNames.invert.key?('three'),
      'ReleaseNameModel has used the names one, two, three from the namelist 1'
    )

    assert_raise(
      NoReleaseNamesLeftException,
      'ReleaseNameModel create throws exception if no release name left '\
      'in the source list to take'
    ) do
      release_names.create('1', 'unit-tests', '4.0.0')
    end

    remove_dir(@@dynamicFilesRoot)
    remove_dir(@@staticFilesRoot)
  end
end
