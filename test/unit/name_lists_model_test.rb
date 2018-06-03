require 'test_helper'

class NameListsModelTest < ActiveSupport::TestCase

  def test_name_lists_index
    prepareTestFiles()
    itemList = NameListsModel.new('/tmp/tests').index
    assert(itemList.kind_of?(Array),'NameListsModel index returns array')
    assert(itemList.sample.key?('id'),'random NameListsModel item has id key')
    assert(itemList.sample.key?('name'),'random NameListsModel item has name key')
  end

  def test_name_lists_item
    prepareTestFiles()
    item1 = NameListsModel.new('/tmp/tests').item("1")
    assert(item1 == ["one","two","three"],'NameListsModel item "1" returns array')
    item2 = NameListsModel.new('/tmp/tests').item("2")
    assert(item2 == ["four","five","six"],'NameListsModel item "2" returns array')
  end

  private

  def prepareTestFiles
    writeFile('/tmp/tests','namelists.json','[{"id":"1","name":"one"},{"id":"2","name":"two"}]')
    writeFile('/tmp/tests/namelists','1.json','["one","two","three"]')
    writeFile('/tmp/tests/namelists','2.json','["four","five","six"]')
  end

end
