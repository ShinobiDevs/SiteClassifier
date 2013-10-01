# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'site_classifier/version'

Gem::Specification.new do |spec|
  spec.name          = "site_classifier"
  spec.version       = SiteClassifier::VERSION
  spec.authors       = ["Elad Meidar"]
  spec.email         = ["elad@eizesus.com"]
  spec.description   = "Return a tag list for submitted urls"
  spec.summary       = "This gem extracts a list of english tags for a given url"
  spec.homepage      = "https://github.com/ShinobiDevs/SiteClassifier"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "httparty", "0.11.0"
  spec.add_dependency "nokogiri", "1.6.0"
  spec.add_dependency "easy_translate", "0.3.3"
  spec.add_dependency "active_support"
end
