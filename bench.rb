# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "benchmark"
require "logfmt"

N = 1_000
line = 'foo=bar a=14 baz="hello kitty" ƒ=2h3s cool%story=bro f %^asdf'

Benchmark.bm(20) do |x|
  x.report("char-by-char") do
    N.times do
      Logfmt.parse(line)
    end
  end
end
