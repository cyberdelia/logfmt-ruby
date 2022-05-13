require "logfmt/logger"

RSpec.describe Logfmt::Logger do
  subject(:logger) { described_class.new(io) }
  let(:io) { StringIO.new }

  it "emits the severity, justified to 5 spaces" do
    logger.warn("Ope")
    expect(io.string).to match(/severity=WARN {2}/)

    logger.error("broke")
    expect(io.string).to match(/severity=ERROR {1}/)
  end

  it "omits nil progname" do
    logger.info("👋 Howdy!")
    expect(io.string).not_to include("progname")
  end

  it "include progname when given" do
    logger.info("AnTest") { "👋 Howdy!" }
    expect(io.string).to include(" progname=AnTest ")
  end

  it "allows an empty message" do
    logger.info
    logger.info(nil)
    expect(io.string).not_to include("msg=")

    io.reopen("")

    logger.info("")
    expect(io.string).to end_with("msg=\n")
  end

  it "handles hash-like objects as key/value pairs" do
    logger.info(at: :start, method: "POST")
    expect(io.string).to include("at=start method=POST")
  end

  it "handles non-hash-like objects as plain strings" do
    logger.info("HERE")
    expect(io.string).to include(" msg=HERE")
  end

  it "accepts msg with other attributes" do
    logger.info(msg: "made it", source: "something-or-another")
    expect(io.string).to include(' msg="made it" source=something-or-another')
  end

  it "errors when given a mix of bare message and attributes" do
    expect { logger.info("bareMessage", some: "attribute") }.to raise_error(ArgumentError)
  end

  it "wraps quotes around messages with whitespace" do
    logger.info("Made it here")
    expect(io.string).to include('msg="Made it here"')
  end

  it "escapes newlines in logged values" do
    message = <<~MSG
      Line 1
      Second line
    MSG

    logger.info(message)
    expect(io.string).to include('Line 1\\nSecond line')
  end

  it "escapes special characters" do
    logger.info("bell\asound")
    expect(io.string).to include('bell\\asound')
  end

  it "escapes quotes in logged values" do
    logger.info(%(It's "good" y'all.))
    expect(io.string).to include(%(msg="It's \\\"good\\\" y'all."))
  end

  it "formats floats truncated to 3 digits" do
    logger.info(duration: Math::PI)
    expect(io.string).to include("duration=3.142")
  end

  it "formats time as ISO8601 strings" do
    logger.debug(at: Time.utc(2000, 1, 2, 3, 4, 5, 6.789))
    expect(io.string).to include("at=2000-01-02T03:04:05.000006Z")
  end

  it "formats true values as bare keys" do
    logger.info(error: true, foo: :bar)
    expect(io.string).to include(" error foo=bar")
  end

  it "formats an array of values by wrapping in quotes and square brackets" do
    logger.info(multi: [1, "two", :three], single: [4.56789])
    expect(io.string).to include(%( multi="[1, two, three]" single=[4.568]))
  end

  it "quotes whitespace in values of an array" do
    logger.info(wspace: ["wow", "white space", :hello])
    expect(io.string).to include(%( wspace="[wow, \\\"white space\\\", hello]"))
  end
end
