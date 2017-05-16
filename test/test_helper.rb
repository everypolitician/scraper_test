$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'scraped'
require 'scraper_test'

require 'minitest/autorun'

class DummyClass < Scraped::HTML
  # This is the class referenced in `./data/valid_instructions.yml`.
  # For an instructions file to be valid, it must reference a known class.
  def to_h
    { id: 34 }
  end
end

class DummyMembersList < Scraped::HTML
  # This is the class referenced in `./data/target_subset_of_members_list_data.yml`.
  # The instructions file specifies a subset of the data returned by to_h.
  def to_h
    { members: [{ id: 1, name: 'Jim' }, { id: 2, name: 'Joe' }] }
  end
end
