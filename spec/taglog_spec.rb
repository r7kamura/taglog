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
    proc {|_, _, program_name, message| "#{program_name}: #{message}" }
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
      it "is wrapped by tag for an argument" do
        klass.new.logger.info("message")
        result.should == ": [tag] message"
      end

      it "is wrapped by tag for return value of block" do
        klass.new.logger.info { "block" + "message" }
        result.should == ": [tag] blockmessage"
      end

      it "is wrapped by tag for an argument with return value of block" do
        klass.new.logger.info("program_name") { "block" + "message" }
        result.should == "program_name: [tag] blockmessage"
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
