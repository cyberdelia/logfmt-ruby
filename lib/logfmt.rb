# frozen_string_literal: true

require "logfmt/version"

module Logfmt
  autoload(:Parser, "logfmt/parser")

  def self.parse(line)
    const_get(:Parser).parse(line)
  end
end
