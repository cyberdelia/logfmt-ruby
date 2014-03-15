# encoding: utf-8
require 'spec_helper'
require 'logfmt/parser_example'

require 'logfmt/hand_parser'

describe Logfmt::HandParser do
  let(:parser) { Logfmt::HandParser.new }
  it_behaves_like "logfmt parser"
end
