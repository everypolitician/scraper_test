require 'test_helper'

class DummyClass
  # This is the class referenced in `./data/valid_instructions.yml`.
  # For an instructions file to be valid, it must reference a known class.
  def to_h
    { id: 34 }
  end
end

describe ScraperTest::Instructions do
  let(:instructions) { ScraperTest::Instructions.new(file) }

  describe 'valid instructions' do
    let(:file) { './test/data/valid_instructions.yml' }

    it 'returns a url' do
      instructions.url.must_equal 'http://majles.marsad.tn/2014/fr/assemblee'
    end

    it 'returns a class to test' do
      instructions.class_to_test.must_equal DummyClass
    end

    it 'returns the expected data' do
      instructions.expected.must_equal(id: 34)
    end
  end

  describe 'invalid instructions' do
    let(:file) { './test/data/invalid_instructions.yml' }

    it 'raises an error when no url is provided' do
      err = -> { instructions.url }.must_raise StandardError
      err.message.must_equal 'No url supplied in invalid_instructions.yml.'
    end

    it 'raises an error when no class to test is provided' do
      err = -> { instructions.class_to_test }.must_raise StandardError
      err.message.must_equal 'No class supplied in invalid_instructions.yml.'
    end

    it 'raises an error when no to_h is provided' do
      err = -> { instructions.expected }.must_raise StandardError
      err.message.must_equal 'No to_h supplied in invalid_instructions.yml.'
    end
  end

  describe 'instructions with empty string as class name' do
    let(:file) { './test/data/empty_string_as_class.yml' }

    it 'raises an error when the class name is an empty string' do
      err = -> { instructions.class_to_test }.must_raise StandardError
      err.message.must_equal 'No class supplied in empty_string_as_class.yml.'
    end
  end

  describe 'instructions with unknown class' do
    let(:file) { './test/data/valid_instructions_with_invalid_class.yml' }

    it 'raises an error if the class is unkown' do
      -> { instructions.class_to_test }.must_raise NameError
    end
  end
end
