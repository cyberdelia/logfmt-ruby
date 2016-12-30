# encoding: utf-8
require 'spec_helper'
require 'logfmt/parser'

describe Logfmt do
  it 'parse empty log line' do
    data = Logfmt.parse('')
    expect(data).to eq({})
  end

  it 'parse whitespace only log line' do
    data = Logfmt.parse("\t")
    expect(data).to eq({})
  end

  it 'parse key without value' do
    data = Logfmt.parse('key')
    expect(data).to eq('key' => true)
  end

  it 'parse key without value and whitespace' do
    data = Logfmt.parse('  key  ')
    expect(data).to eq('key' => true)
  end

  it 'parse multiple single keys' do
    data = Logfmt.parse('key1 key2')
    expect(data).to eq('key1' => true, 'key2' => true)
  end

  it 'parse unquoted value' do
    data = Logfmt.parse('key=value')
    expect(data).to eq('key' => 'value')
  end

  it 'parse pairs' do
    data = Logfmt.parse('key1=value1 key2=value2')
    expect(data).to eq('key1' => 'value1', 'key2' => 'value2')
  end

  it 'parse mixed single/non-single pairs' do
    data = Logfmt.parse('key1=value1 key2')
    expect(data).to eq('key1' => 'value1', 'key2' => true)
  end

  it 'parse mixed pairs whatever the order' do
    data = Logfmt.parse('key1 key2=value2')
    expect(data).to eq('key1' => true, 'key2' => 'value2')
  end

  it 'parse quoted value' do
    data = Logfmt.parse('key="quoted value"')
    expect(data).to eq('key' => 'quoted value')
  end

  it 'parse escaped quote value ' do
    data = Logfmt.parse('key="quoted \" value" r="esc\t"')
    expect(data).to eq('key' => 'quoted \" value', 'r' => 'esc\\t')
  end

  it 'parse mixed pairs' do
    data = Logfmt.parse('key1="quoted \" value" key2 key3=value3')
    expect(data).to eq('key1' => 'quoted \" value', 'key2' => true, 'key3' => 'value3')
  end

  it 'parse mixed characters pairs' do
    data = Logfmt.parse('foo=bar a=14 baz="hello kitty" ƒ=2h3s cool%story=bro f %^asdf')
    expect(data).to eq('foo' => 'bar', 'a' => 14, 'baz' => 'hello kitty',
      'ƒ' => '2h3s', 'cool%story' => 'bro', 'f' => true, '%^asdf' => true)
  end

  it 'parse pair with empty quote' do
    data = Logfmt.parse('key=""')
    expect(data).to eq('key' => '')
  end

  # Currently, the value comes back as "true", which could mess up stats
  # Really, only "true" should come back as "true"
  # it 'parse 1 as integer type' do
  #   data = Logfmt.parse('key=1')
  #   expect(data['key'].class).to eq(Fixnum)
  # end

  it 'parse positive integer as integer type' do
    data = Logfmt.parse('key=234')
    expect(data['key']).to eq(234)
    expect(data['key'].class).to eq(Fixnum)
  end

  it 'parse negative integer as integer type' do
    data = Logfmt.parse('key=-3428')
    expect(data['key']).to eq(-3428)
    expect(data['key'].class).to eq(Fixnum)
  end

  it 'parse positive float as float type' do
    data = Logfmt.parse('key=3.342')
    expect(data['key']).to eq(3.342)
    expect(data['key'].class).to eq(Float)
  end

  it 'parse negative float as float type' do
    data = Logfmt.parse('key=-0.9934')
    expect(data['key']).to eq(-0.9934)
    expect(data['key'].class).to eq(Float)
  end

  it 'parse exponential float as float type' do
    data = Logfmt.parse('key=2.342342342342344e+18')
    expect(data['key']).to eq(2.342342342342344e+18)
    expect(data['key'].class).to eq(Float)
  end

  it 'parse quoted integer as string type' do
    data = Logfmt.parse('key="234"')
    expect(data['key'].class).to eq(String)
  end

  it 'parse quoted float as string type' do
    data = Logfmt.parse('key="3.14"')
    expect(data['key'].class).to eq(String)
  end

  it 'parse IP address as string type' do
    data = Logfmt.parse('key=10.10.10.1')
    expect(data['key'].class).to eq(String)
  end

  it 'parse last as integer type' do
    data = Logfmt.parse('key1=4 key2=9')
    expect(data['key1']).to eq(4)
    expect(data['key2']).to eq(9)
  end

  it 'parse value containg equal sign' do
    query = 'position=44.80450799126121%2C33.58320759981871&uid=1'
    data = Logfmt.parse("method=GET query=#{query} status=200")
    expect(data).to eq(
      'method' => 'GET',
      'query' => query,
      'status' => 200
    )
  end
end
