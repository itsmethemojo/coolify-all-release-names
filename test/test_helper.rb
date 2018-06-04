# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'fileutils'

class ActiveSupport::TestCase
  fixtures :all

  @@static_files_root = '/tmp/tests/static'
  @@dynamic_files_root = '/tmp/tests/dynamic'

  private

  def prepare_static_test_files(files_root)
    write_file(
      files_root,
      'namelists.json',
      '[{"id":"1","name":"one"},{"id":"2","name":"two"}]'
    )
    write_file(files_root + '/namelists', '1.json', '["one","two","three"]')
    write_file(files_root + '/namelists', '2.json', '["four","five","six"]')
  end

  def write_file(folderpath, filename, content)
    FileUtils.mkdir_p(folderpath) unless File.directory?(folderpath)
    file = File.new(folderpath + '/' + filename, 'w')
    file.write(content)
    file.close
  end

  def remove_dir(folderpath)
    FileUtils.remove_dir(folderpath)
  end
end
