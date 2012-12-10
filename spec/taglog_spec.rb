require "spec_helper"
require "logger"
require "stringio"

describe Taglog do
  let(:taglog) do
    described_class.new(tag)
  end

  let(:tag) do
    "tag"
  end

  let(:logger) do
    Logger.new(io).tap do |this|
      this.formatter = formatter
    end
  end

  let(:formatter) do
    proc {|_, _, _, message| message }
  end

  let(:io) do
    StringIO.new
  end

  let(:result) do
    io.string
  end

  let(:klass) do
    logger = logger()
    Class.new do
      define_method(:logger) do
        logger
      end
    end
  end

  describe "#extended" do
    before do
      klass.extend taglog
    end

    describe "#info" do
      it "is wrapped by tag" do
        klass.new.logger.info("message")
        result.should == "[tag] message"
      end
    end

    describe "#method_missing" do
      before do
        logger.stub(:missing => "missing")
      end

      it "is delegated to original logger" do
        klass.new.logger.missing.should == "missing"
      end
    end
  end
end
