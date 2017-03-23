require 'scraper_test/version'
require 'rake/tasklib'

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
              yaml_data = YAML.load_file(file).to_h
              url = yaml_data[:url]
              class_to_test = Object.const_get(yaml_data[:class])
              VCR.use_cassette(File.basename(url)) do
                response = class_to_test.new(response: Scraped::Request.new(url: url).response)
                yaml_data[:to_h].must_equal response.to_h
              end
            end
          end
        end
      end
    end
  end
end
