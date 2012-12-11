require "taglog/version"
require "logger"
require "stringio"

# Wrap a class that has `#logger` method to insert tag
# without over defining actual logger's methods.
class Taglog < Module
  LEVELS = Logger::Severity.constants.map(&:downcase)

  def initialize(tag)
    @tag = tag
  end

  def extended(base)
    tag = @tag
    base.class_eval do
      define_method(:logger_with_tag) do
        Proxy.new(self, tag)
      end
      alias_method :logger_without_tag, :logger
      alias_method :logger, :logger_with_tag
    end
  end

  class Proxy
    def initialize(context, tag)
      @context = context
      @tag     = tag
    end

    LEVELS.each do |level|
      define_method(level) do |message|
        delegate(level, tagged(message))
      end
    end

    def method_missing(name, *args)
      delegate(name, *args)
    end

    attr_reader :context, :tag
    private :context, :tag

    private

    def tagged(message)
      "[#{tag}] #{message}"
    end

    def delegate(method_name, *args)
      logger.send(method_name, *args)
    end

    def logger
      context.send(:logger_without_tag)
    end
  end
end
