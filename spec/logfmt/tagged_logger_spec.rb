# frozen_string_literal: true

require "logfmt/tagged_logger"

RSpec.describe Logfmt::TaggedLogger do
  subject(:logger) { described_class.new(io) }

  let(:io) { StringIO.new }

  it "prepends tags to the message" do
    logger.tagged(source: "Spec") { logger.info(hello: "World") }
    expect(io.string).to include(" source=Spec hello=World")
  end

  it "merges duplicate tags by key in nested contexts" do
    logger.tagged(source: "Outter") do
      logger.tagged(source: "Inner") do
        logger.info(hello: "World")
      end

      logger.warn(hello: "Again")
    end

    expect(io.string).to include(" source=Inner hello=World")
    expect(io.string).to include(" source=Outter hello=Again")
  end

  it "wraps bare tags in square brackets" do
    logger.tagged("BareTagHere") { logger.info(hello: "World") }
    expect(io.string).to include(" tags=[BareTagHere] hello=World")
  end

  it "wrap quotes around bare tags with whitespace" do
    logger.tagged("Bare tag here") { logger.info(hello: "World") }
    expect(io.string).to include(' tags="[Bare tag here]"')
  end

  it 'collects multiple bare tags under the "tags" key' do
    logger.tagged("1.2.3.4", "BareTagHere") { logger.info(hello: "World") }
    expect(io.string).to include(' tags="[1.2.3.4] [BareTagHere]" hello=World')
  end

  it "allows a mix of bare tags and key/value pairs" do
    logger.tagged("bare", key: "value") { logger.info(hello: "World") }
    expect(io.string).to include(" tags=[bare] key=value hello=World")
  end

  it "omits the 'tags' when there are no bare tags" do
    logger.tagged(source: "here") { logger.info("Hello") }
    expect(io.string).not_to include("tags=")
  end

  it "escapes quotes in tags" do
    logger.tagged(%(It's "good" y'all), context: %(It's "bad" y'all)) { logger.info }

    expect(io.string).to include(%( tags="[It's \\\"good\\\" y'all]" context="It's \\\"bad\\\" y'all"))
  end
end
