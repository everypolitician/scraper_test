require 'scraper_test/version'
require 'minitest/spec'

module ScraperTest
  class Test < ::Minitest::Test
    def test_scraper
      # TODO: Make this configurable
      Dir['test/data/*.yml'].each do |file|
        yaml_data = YAML.load_file(file).to_h
        url = yaml_data[:url]
        class_to_test = Object.const_get(yaml_data[:class])
        VCR.use_cassette(File.basename(url)) do
          response = class_to_test.new(response: Scraped::Request.new(url: url).response)
          assert_equal yaml_data[:to_h], response.to_h
        end
      end
    end
  end

  class RakeTask < ::Rake::TaskLib
    attr_reader :name

    def initialize(name = :test)
      @name = name
    end

    def install_tasks
      task(name) do
        require 'pry'
        require 'vcr'
        require 'webmock'

        Dir['lib/**/*.rb'].each { |f| require File.expand_path(f) }

        VCR.configure do |c|
          # TODO: Make this configurable
          c.cassette_library_dir = 'test/cassettes'
          c.hook_into :webmock
        end

        Minitest.run

        VCR.turn_off!
        WebMock.disable!
      end
    end
  end
end
