# frozen_string_literal: true

require_relative "lib/logfmt/version"
require "English"

Gem::Specification.new do |spec|
  spec.name = "logfmt"
  spec.version = Logfmt::VERSION
  spec.authors = ["Timothée Peignier"]
  spec.email = ["timothee.peignier@tryphon.org"]

  spec.summary = "Write and parse logfmt messages."
  spec.description = "Write and parse log lines in the logfmt style."
  spec.homepage = "https://github.com/cyberdelia/logfmt-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blog/master/CHANGELOG.md",
    "documentation_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
      .reject { |f|
        (f == __FILE__) ||
          f.match?(%r{\A(?:(?:bin|spec|features)/|\.(?:git|github))}) ||
          f.match?(/tagged_logger/)
      }
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
