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

  describe 'accepts an output size limit' do
    obj = {lorem: 'ipsum', dolor: 'sit', amet: 'consectetur'}
    output1 = 'lorem=ipsum ...'
    output2 = 'lorem=ipsum dolor=sit ...'
    output3 = 'lorem=ipsum dolor=sit amet=consectetur'

    it{ expect(generator.generate(obj, limit: 1)).to eq('...') }
    it{ expect(generator.generate(obj, limit: 10)).to eq('...') }
    it{ expect(generator.generate(obj, limit: 11)).to eq(output1) }
    it{ expect(generator.generate(obj, limit: 20)).to eq(output1) }
    it{ expect(generator.generate(obj, limit: 21)).to eq(output2) }
    it{ expect(generator.generate(obj, limit: 37)).to eq(output2) }
    it{ expect(generator.generate(obj, limit: 38)).to eq(output3) }
  end
end
