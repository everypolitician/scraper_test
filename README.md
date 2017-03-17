# ScraperTest

Data-driven scraper tests for Scraped.

## Installation

Add this line to your application's Gemfile:

```ruby
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }
gem 'scraper_test', github: 'everypolitician/scraper_test'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scraper_test

## Usage

Add the following to your `Rakefile`:

```ruby
require 'scraper_test'
ScraperTest::RakeTask.new.install_tasks
```

Then you can drop a YAML file into the `test/data/` directory the looks like the following:

```yaml
:url: http://example.com
:class: ExamplePage
:to_h:
  :title: Example Domain
```

This will create a new instance of the `ExamplePage` class and then pass it a `Scraped::Response` for the `:url`. It will then assert that the `ExamplePage#to_h` method returns the same as the `:to_h:` hash specifies in the YAML.

### Running the tests

To actually test the YAML files you've written you'll need to run the `test:data` rake task:

    bundle exec rake test:data

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/scraper_test.
