require 'test_helper'

class ReleaseNamesModelTest < ActiveSupport::TestCase

  def test_release_names_index_create
    prepareStaticTestFiles(@@staticFilesRoot)
    nameList = NameListsModel.new(@@staticFilesRoot)
    assert_raise(
      NoSuchEntityException,
      'ReleaseNameModel index throws exception if no release name for that project was ever created'
    ) {
      ReleaseNamesModel.new(@@dynamicFilesRoot,nameList).index('1', 'unit-tests')
    }

    keyValueReturn1 = ReleaseNamesModel.new(@@dynamicFilesRoot,nameList).create('1', 'unit-tests', '1.0.0')
    assert(keyValueReturn1.key?('1.0.0'),'ReleaseNameModel return key value if item is created')

    keyValueReturn2 = ReleaseNamesModel.new(@@dynamicFilesRoot,nameList).create('1', 'unit-tests', '2.0.0')
    assert(keyValueReturn2.key?('2.0.0'),'ReleaseNameModel return key value if item is created')

    keyValueReturn3 = ReleaseNamesModel.new(@@dynamicFilesRoot,nameList).create('1', 'unit-tests', '3.0.0')
    assert(keyValueReturn3.key?('3.0.0'),'ReleaseNameModel return key value if item is created')

    keyValueReturn4 = ReleaseNamesModel.new(@@dynamicFilesRoot,nameList).create('1', 'unit-tests', '3.0.0')
    assert(keyValueReturn4.key?('3.0.0'),'ReleaseNameModel return same key if release was already named')


    releaseNames = ReleaseNamesModel.new(@@dynamicFilesRoot,nameList).index('1', 'unit-tests')

    assert(releaseNames.keys.length == 3,'ReleaseNameModel has key 1.0.0')
    assert(releaseNames.key?('1.0.0'),'ReleaseNameModel has key 1.0.0')
    assert(releaseNames.key?('2.0.0'),'ReleaseNameModel has key 2.0.0')
    assert(releaseNames.key?('3.0.0'),'ReleaseNameModel has key 3.0.0')

    assert(releaseNames.invert.key?('one'),'ReleaseNameModel has used the names one, two and three from the namelist 1')
    assert(releaseNames.invert.key?('two'),'ReleaseNameModel has used the names one, two and three from the namelist 1')
    assert(releaseNames.invert.key?('three'),'ReleaseNameModel has used the names one, two and three from the namelist 1')



    assert_raise(
      NoReleaseNamesLeftException,
      'ReleaseNameModel create throws exception if no release name left in the source list to take'
    ) {
      ReleaseNamesModel.new(@@dynamicFilesRoot,nameList).create('1', 'unit-tests', '4.0.0')
    }

    remove_dir(@@dynamicFilesRoot)
    remove_dir(@@staticFilesRoot)
  end

end
