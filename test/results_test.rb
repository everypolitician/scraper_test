require 'test_helper'

describe ScraperTest::Results do
  let(:file) { './test/data/member_data.yml' }
  let(:expected) { YAML.load_file(file).to_h[:to_h] }
  let(:results) { ScraperTest::Results.new(file) }

  it 'returns the expected result' do
    results.expected.must_equal expected
  end
end
