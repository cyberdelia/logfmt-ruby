# frozen_string_literal: true

require_relative "lib/logfmt/version"

Gem::Specification.new do |spec|
  spec.name = "logfmt-tagged_logger"
  spec.version = Logfmt::VERSION
  spec.authors = ["Steven Harman"]
  spec.email = ["steven@harmanly.com"]

  spec.summary = "An ActiveSupport::TaggedLogging compatible logger for logfmt."
  spec.description = "Make logfmt aware of ActiveSupport::TaggedLogging to write logfmt-styled log lines, with tags!"
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
    `git ls-files lib | grep tagged_logger`.split("\x0") + ["README.md", "CHANGELOG.md"]
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "logfmt", Logfmt::VERSION
  spec.add_runtime_dependency "activesupport", ">= 6.0"
end
