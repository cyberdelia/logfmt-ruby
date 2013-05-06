# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logfmt/version'

Gem::Specification.new do |gem|
  gem.name          = "logfmt"
  gem.version       = Logfmt::VERSION
  gem.authors       = ["Timothée Peignier"]
  gem.email         = ["timothee.peignier@tryphon.org"]
  gem.description   = %q{Parse log lines in the logfmt style.}
  gem.summary       = %q{Parse logfmt messages.}
  gem.homepage      = "https://github.com/cyberdelia/logfmt-ruby"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "parslet"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
end