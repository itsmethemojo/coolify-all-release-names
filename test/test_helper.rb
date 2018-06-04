# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'fileutils'

module ActiveSupport
  class TestCase
    fixtures :all

    STATIC_ROOT = '/tmp/tests/static'
    DYNAMIC_ROOT = '/tmp/tests/dynamic'

    private

    def prepare_static_test_files
      write_file(
        static_root,
        'namelists.json',
        '[{"id":"1","name":"one"},{"id":"2","name":"two"}]'
      )
      write_file(static_root + '/namelists', '1.json', '["one","two","three"]')
      write_file(static_root + '/namelists', '2.json', '["four","five","six"]')
    end

    def write_file(folderpath, filename, content)
      FileUtils.mkdir_p(folderpath) unless File.directory?(folderpath)
      file = File.new(folderpath + '/' + filename, 'w')
      file.write(content)
      file.close
    end

    def remove_dir(path)
      FileUtils.rm_rf(path)
    end

    def static_root
      STATIC_ROOT
    end

    def dynamic_root
      DYNAMIC_ROOT
    end

    def setup
      prepare_static_test_files
    end

    def teardown
      remove_dir(static_root)
      remove_dir(dynamic_root)
    end
  end
end
