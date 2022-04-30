# frozen_string_literal: true

# require File.expand_path("../lib/dumb_delegator", File.dirname(__FILE__))
require "logfmt"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.disable_monkey_patching!
  config.warnings = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.order = "random"
  Kernel.srand config.seed
end
