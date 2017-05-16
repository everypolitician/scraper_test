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
              VCR.use_cassette(File.basename(file)) do
                instructions = Instructions.new(file)
                Test.new(instructions).compare { |a, b| a.must_equal b }
              end
            end
          end
        end
      end
    end
  end

  class Test
    def initialize(instructions)
      @instructions = instructions
    end

    def compare
      yield(actual, instructions.expected)
    end

    private

    def actual
      return response.to_h unless target
      target_data = response.to_h.values[0].find { |v| v.merge(target) == v }
      raise "Cannot find #{target} in response data." if target_data.nil?
      target_data
    end

    attr_reader :instructions

    def response
      instructions.class_to_test.new(response: Scraped::Request.new(url: instructions.url).response)
    end

    def target
      instructions.target
    end
  end

  class Instructions
    def initialize(filename)
      @filename = filename
    end

    def url
      test_data[:url] or raise "No url supplied in #{filepath.basename}."
    end

    def class_to_test
      raise "No class supplied in #{filepath.basename}." if test_data[:class].to_s.empty?
      Object.const_get(test_data[:class])
    end

    def expected
      test_data[:to_h] or raise "No to_h supplied in #{filepath.basename}."
    end

    def target
      test_data[:target]
    end

    private

    attr_reader :filename

    def filepath
      @filepath ||= Pathname.new(filename)
    end

    def test_data
      @test_data ||= YAML.load_file(filepath)
    end
  end
end
