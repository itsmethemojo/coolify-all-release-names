# frozen_string_literal: true

require 'test_helper'

class SourceFilesTest < ActiveSupport::TestCase
  def test_main_source_file_length1
    assert(json_files.is_a?(Array), 'object is array')
    assert(main_file_object.is_a?(Array), 'object is array')
  end

  def test_main_source_file_length2
    assert(json_files.length > 1, 'there are more then 1 source file')
    assert(
      main_file_object.length == json_files.length,
      'main file matches sub files count'
    )
  end

  def test_main_source_file_structure
    main_file_object.each do |entry|
      assert(entry.key?('name'), 'entry has name')
      assert(
        json_files.include?(prefix + entry['id'] + '.json'),
        'for key there exists a file'
      )
    end
  end

  def test_sub_source_files_structure
    json_files.each do |json_file|
      list = JSON.parse(File.read(json_file))
      assert(list.is_a?(Array), 'structure is a list')
      list.each do |item|
        assert(item.is_a?(String), 'items in list is string')
      end
    end
  end

  private

  def json_files
    Dir.glob(Rails.root.join('storage', 'namelists', '*.json'))
  end

  def prefix
    Rails.root.join('storage', 'namelists').to_s + '/'
  end

  def main_file_object
    JSON.parse(File.read(Rails.root.join('storage', 'namelists.json')))
  end
end
