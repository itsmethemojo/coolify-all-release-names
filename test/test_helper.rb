ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def writeFile(folderPath, filename, content)
    if !File.directory?(folderPath)
      Dir.mkdir(folderPath)
    end
    file = File.new(folderPath + '/' + filename,'w')
    file.write(content)
    file.close
  end
end
