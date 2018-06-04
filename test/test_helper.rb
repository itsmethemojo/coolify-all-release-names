# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'fileutils'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  @@staticFilesRoot = '/tmp/tests/static'
  @@dynamicFilesRoot = '/tmp/tests/dynamic'

  private

  def prepareStaticTestFiles(filesRoot)
    writeFile(filesRoot, 'namelists.json', '[{"id":"1","name":"one"},{"id":"2","name":"two"}]')
    writeFile(filesRoot + '/namelists', '1.json', '["one","two","three"]')
    writeFile(filesRoot + '/namelists', '2.json', '["four","five","six"]')
  end

  def writeFile(folderPath, filename, content)
    FileUtils.mkdir_p(folderPath) unless File.directory?(folderPath)
    file = File.new(folderPath + '/' + filename, 'w')
    file.write(content)
    file.close
  end

  def remove_dir(folderPath)
    FileUtils.remove_dir(folderPath)
  end
end
