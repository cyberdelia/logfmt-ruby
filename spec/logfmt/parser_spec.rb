RSpec.describe Logfmt::Parser do
  subject(:parser) { described_class }

  it "parses empty log line" do
    data = parser.parse("")
    expect(data).to eq({})
  end

  it "parses whitespace only log line" do
    data = parser.parse("\t")
    expect(data).to eq({})
  end

  it "parses key without value" do
    data = parser.parse("key")
    expect(data).to eq("key" => true)
  end

  it "parses key without value and whitespace" do
    data = parser.parse("  key  ")
    expect(data).to eq("key" => true)
  end

  it "parses multiple single keys" do
    data = parser.parse("key1 key2")
    expect(data).to eq("key1" => true, "key2" => true)
  end

  it "parses unquoted value" do
    data = parser.parse("key=value")
    expect(data).to eq("key" => "value")
  end

  it "parses pairs" do
    data = parser.parse("key1=value1 key2=value2")
    expect(data).to eq("key1" => "value1", "key2" => "value2")
  end

  it "parses mixed single/non-single pairs" do
    data = parser.parse("key1=value1 key2")
    expect(data).to eq("key1" => "value1", "key2" => true)
  end

  it "parses mixed pairs whatever the order" do
    data = parser.parse("key1 key2=value2")
    expect(data).to eq("key1" => true, "key2" => "value2")
  end

  it "parses quoted value" do
    data = parser.parse('key="quoted value"')
    expect(data).to eq("key" => "quoted value")
  end

  it "parses escaped quote value " do
    data = parser.parse('key="quoted \" value" r="esc\t"')
    expect(data).to eq("key" => 'quoted " value', "r" => 'esc\t')
  end

  it "parses mixed pairs" do
    data = parser.parse('key1="quoted \" value" key2 key3=value3')
    expect(data).to eq("key1" => 'quoted " value', "key2" => true, "key3" => "value3")
  end

  it "parses mixed characters pairs" do
    data = parser.parse('foo=bar a=14 baz="hello kitty" ƒ=2h3s cool%story=bro f %^asdf')
    expect(data).to eq("foo" => "bar", "a" => 14, "baz" => "hello kitty",
      "ƒ" => "2h3s", "cool%story" => "bro", "f" => true, "%^asdf" => true)
  end

  it "parses pair with empty quote" do
    data = parser.parse('key=""')
    expect(data).to eq("key" => "")
  end

  # Currently, the value comes back as "true", which could mess up stats
  # Really, only "true" should come back as "true"
  # it 'parse 1 as integer type' do
  #   data = parser.parse('key=1')
  #   expect(data['key'].class).to eq(Fixnum)
  # end

  it "parses positive integer as integer type" do
    data = parser.parse("key=234")
    expect(data["key"]).to eq(234)
    expect(data["key"].class).to eq(Integer)
  end

  it "parses negative integer as integer type" do
    data = parser.parse("key=-3428")
    expect(data["key"]).to eq(-3428)
    expect(data["key"].class).to eq(Integer)
  end

  it "parses positive float as float type" do
    data = parser.parse("key=3.342")
    expect(data["key"]).to eq(3.342)
    expect(data["key"].class).to eq(Float)
  end

  it "parses negative float as float type" do
    data = parser.parse("key=-0.9934")
    expect(data["key"]).to eq(-0.9934)
    expect(data["key"].class).to eq(Float)
  end

  it "parses exponential float as float type" do
    data = parser.parse("key=2.342342342342344e+18")
    expect(data["key"]).to eq(2.342342342342344e+18)
    expect(data["key"].class).to eq(Float)
  end

  it "parses long digit string with embedded e as string" do
    data = parser.parse("key=2342342342342344e1818")
    expect(data["key"].class).to eq(String)
  end

  it "parses quoted integer as string type" do
    data = parser.parse('key="234"')
    expect(data["key"].class).to eq(String)
  end

  it "parses quoted float as string type" do
    data = parser.parse('key="3.14"')
    expect(data["key"].class).to eq(String)
  end

  it "parses IP address as string type" do
    data = parser.parse("key=10.10.10.1")
    expect(data["key"].class).to eq(String)
  end

  it "parses last as integer type" do
    data = parser.parse("key1=4 key2=9")
    expect(data["key1"]).to eq(4)
    expect(data["key2"]).to eq(9)
  end

  it "parses string containing quotes" do
    data = parser.parse('key1="{\"msg\": \"hello\tworld\"}"')
    expect(data["key1"]).to eq('{"msg": "hello\tworld"}')
  end

  it "parses value containing equal sign" do
    query = "position=44.80450799126121%2C33.58320759981871&uid=1"
    data = parser.parse("method=GET query=#{query} status=200")
    expect(data).to eq(
      "method" => "GET",
      "query" => query,
      "status" => 200
    )
  end

  it "parses integers correctly" do
    data = parser.parse("key=111 ")
    expect(data["key"]).to eq(111)
  end
end
