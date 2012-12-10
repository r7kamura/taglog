# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taglog/version'

Gem::Specification.new do |gem|
  gem.name          = "taglog"
  gem.version       = Taglog::VERSION
  gem.authors       = ["Ryo Nakamura"]
  gem.email         = ["ryo-nakamura@cookpad.com"]
  gem.description   = "Taglog provides taggable logger extension"
  gem.summary       = "Taggable logger extension"
  gem.homepage      = "https://github.com/r7kamura/taglog"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "2.12.0"
end
