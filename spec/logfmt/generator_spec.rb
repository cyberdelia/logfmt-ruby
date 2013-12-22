# encoding: utf-8
require 'spec_helper'
require 'logfmt/parser_example'

require 'logfmt/generator'

describe Logfmt::Generator do
  let(:generator) { Logfmt::Generator }

  examples = {
    'foo' => 'msg=foo',
    {foo: 4} => 'foo=4',
    '' => 'msg=""',
    true => 'msg=true',
    false => 'msg=false',
    nil => 'msg=nil',
  }

  examples.each_pair do |obj, result|
    it "generates #{obj.inspect} to #{result.inspect}" do
      expect(generator.generate(obj)).to eq(result)
    end
  end

  it 'works with BasicObject' do
    expect(generator.generate(BasicObject.new)).to eq('msg=...')
  end
end
