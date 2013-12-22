# encoding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)

require 'logfmt/parser'
require 'logfmt/hand_parser'
require 'logfmt/regexp_parser'
require 'logfmt/generator'

require 'benchmark'
require 'minitest/unit'

include MiniTest::Assertions

N = 1_000
line = 'foo=bar a=14 baz="hello kitty" ƒ=2h3s cool%story=bro f %^asdf'

parsed = Logfmt.parse(line)
p parsed
parsed2 = Logfmt::HandParser.parse(line)
parsed3 = Logfmt::RegexpParser.parse(line)
assert_equal parsed, parsed2
assert_equal parsed, parsed3

Benchmark.bm(20) do |x|
  x.report('parslet') do
    N.times do
      Logfmt.parse(line)
    end
  end

  x.report('hand') do
    N.times do
      Logfmt::HandParser.parse(line)
    end
  end

  x.report('regexp') do
    N.times do
      Logfmt::RegexpParser.parse(line)
    end
  end

  x.report('gen') do
    N.times do
      Logfmt::Generator.generate(parsed)
    end
  end
end

