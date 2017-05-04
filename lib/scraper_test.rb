require 'scraper_test/version'
require 'rake/tasklib'
require 'yaml'

module ScraperTest
  class RakeTask < ::Rake::TaskLib
    attr_reader :name

    def initialize(name = 'test:data')
      @name = name
    end

    def install_tasks
      task(name) do
        require 'minitest/autorun'
        require 'pry'
        require 'vcr'
        require 'webmock'

        Dir['lib/**/*.rb'].each { |f| require File.expand_path(f) }

        VCR.configure do |c|
          # TODO: Make this configurable
          c.cassette_library_dir = 'test/cassettes'
          c.hook_into :webmock
        end

        Minitest.after_run { VCR.turn_off! }

        describe 'Scraper tests' do
          it 'should contain the expected data' do
            # TODO: Make this configurable
            Dir['test/data/*.yml'].each do |file|
              test_results = Results.new(file)
              test_results.actual.must_equal test_results.expected
            end
          end
        end
      end
    end
  end

  class Results
    def initialize(file)
      @file = file
    end

    def actual
      VCR.use_cassette(File.basename(url)) do
        class_to_test.new(response: Scraped::Request.new(url: url).response).to_h
      end
    end

    def expected
      yaml_data[:to_h]
    end

    private

    attr_reader :file

    def class_to_test
      Object.const_get(yaml_data[:class])
    end

    def url
      yaml_data[:url]
    end

    def yaml_data
      @yaml_data ||= YAML.load_file(file).to_h
    end
  end
end
