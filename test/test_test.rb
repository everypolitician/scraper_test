require 'test_helper'

describe ScraperTest::Test do
  let(:instructions) { ScraperTest::Instructions.new(file) }
  let(:subject) { ScraperTest::Test.new(instructions) }

  let(:equality_test) do
    proc { subject.compare { |actual, expected| actual.must_equal expected } }
  end

  describe 'Instructions without specified target' do
    let(:file) { './test/data/valid_instructions.yml' }

    it 'will pass' do
      equality_test.call
    end
  end

  describe 'Test data with specified target' do
    let(:file) { './test/data/instructions_with_target.yml' }

    it 'will pass' do
      equality_test.call
    end
  end

  describe 'Test data with target key that does not match source data' do
    let(:file) { './test/data/instructions_with_target_with_invalid_key.yml' }

    it 'will raise the expected error' do
      err = -> { equality_test.call }.must_raise StandardError
      err.message.must_equal 'Cannot find {:key_not_present=>23} in response data.'
    end
  end

  describe 'Test data with a non-existing key value pair where the key is known' do
    let(:file) { './test/data/instructions_with_target_with_known_key_with_unknown_value.yml' }
    
    it 'will raise the expected error' do
      err = -> { equality_test.call }.must_raise StandardError
      err.message.must_equal 'Cannot find {:id=>"unkown value"} in response data.'
    end
  end

  describe 'Test data with an invalid path' do
    let(:file) { './test/data/instructions_with_target_with_invalid_target.yml' }

    it 'will raise the expected error' do
      err = -> { equality_test.call }.must_raise StandardError
      err.message.must_equal 'Cannot find {:id=>"unkown"} in response data.'
    end
  end
end
