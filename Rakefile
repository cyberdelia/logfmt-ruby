# frozen_string_literal: true

require "bundler/gem_helper"
require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec)

namespace "logfmt" do
  Bundler::GemHelper.install_tasks name: "logfmt"
end

# Inspired by how dotenv/dotenv-rails handles mulitple Gems in a single repo
class LogFmtTaggedLoggerGemHelper < Bundler::GemHelper
  def guard_already_tagged
    # noop
  end

  def tag_version
    # noop
  end
end

namespace "logfmt-tagged_logger" do
  LogFmtTaggedLoggerGemHelper.install_tasks name: "logfmt-tagged_logger"
end

desc "Build logfmt and logfmt-tagged_logger into the pkg directory"
task build: ["logfmt:build", "logfmt-tagged_logger:build"]

desc "Build and install logfmt and logfmt-tagged_logger into system gems"
task install: ["logfmt:install", "logfmt-tagged_logger:install"]

desc "Create tag, build, and push logfmt and logfmt-tagged_logger to rubygems.org"
task release: ["logfmt:release", "logfmt-tagged_logger:release"]

task default: :spec
