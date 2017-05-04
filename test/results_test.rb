require 'test_helper'
require 'scraped'

class DummyClass < Scraped::HTML
  field :id do
    [term, File.basename(url, '.htm')].join('/')
  end

  field :term do
    File.dirname(url).split('/').last
  end
end

describe ScraperTest::Results do
  let(:file) { './test/data/member_data.yml' }
  let(:expected) { YAML.load_file(file).to_h[:to_h] }
  let(:results) { ScraperTest::Results.new(file) }

  around { |test| VCR.use_cassette(File.basename(file), &test) }

  it 'returns the expected result' do
    results.expected.must_equal expected
  end

  it 'returns the actual result' do
    results.actual.must_equal expected
  end
end
