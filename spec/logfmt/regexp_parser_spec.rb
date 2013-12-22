# encoding: utf-8
require 'spec_helper'
require 'logfmt/parser_example'

require 'logfmt/regexp_parser'

describe Logfmt::RegexpParser do
  let(:parser) { Logfmt::RegexpParser }
  it_behaves_like "logfmt parser"
end
