# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scraper_test/version'

Gem::Specification.new do |spec|
  spec.name          = 'scraper_test'
  spec.version       = ScraperTest::VERSION
  spec.authors       = ['EveryPolitician team']
  spec.email         = ['team@everypolitician.org']

  spec.summary       = 'Write data-driven tests for scrapers'
  spec.homepage      = 'https://github.com/everypolitician/scraper_test'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'minitest', '~> 5.0'
  spec.add_runtime_dependency 'pry'
  spec.add_runtime_dependency 'webmock', '>= 2.0'
  spec.add_runtime_dependency 'vcr', '>= 3.0.3'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'scraped'
end
