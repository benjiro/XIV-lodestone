# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xiv_lodestone/version'

Gem::Specification.new do |spec|
  spec.name          = "xiv_lodestone"
  spec.version       = XIVLodestone::VERSION
  spec.authors       = ["Benjamin Evenson"]
  spec.email         = ["bevenson@gmail.com"]
  spec.summary       = %q{A webscraper for FFXIV:ARR lodestone website.}
  spec.description   = %q{A Ruby library for scraping information about a given character from the FFXIV lodestone website. More to come...}
  spec.homepage      = "https://github.com/benjiro/XIV-lodestone"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.2"

  spec.add_dependency("nokogiri", "~> 1.6")

  spec.add_development_dependency("bundler", "~> 1.7")
  spec.add_development_dependency("rspec", "~> 3.1")
  spec.add_development_dependency("rake", "~> 10.0")
end
