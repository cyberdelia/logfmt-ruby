# frozen_string_literal: true

require_relative "lib/logfmt/version"

Gem::Specification.new do |spec|
  spec.name = "logfmt"
  spec.version = Logfmt::VERSION
  spec.authors = ["Timothée Peignier"]
  spec.email = ["timothee.peignier@tryphon.org"]

  spec.summary = "Parse logfmt messages."
  spec.description = "Parse log lines in the logfmt style."
  spec.homepage = "https://github.com/cyberdelia/logfmt-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blog/master/CHANGELOG.md",
    "documentation_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
