# frozen_string_literal: true

require_relative "../logfmt"
require "logger"
require "time"

module Logfmt
  class Logger < ::Logger
    def initialize(*args, **kwargs)
      super
      @formatter ||= KeyValueFormatter.new
    end

    class KeyValueFormatter < ::Logger::Formatter
      def call(severity, timestamp, progname, msg)
        %(time=#{format_datetime(timestamp)} severity=#{severity.ljust(5)}#{format_progname(progname)} #{format_message(msg)}\n)
      end

      private

      def format_datetime(time)
        time.utc.iso8601(6)
      end

      def format_message(msg)
        return unless msg

        if msg.respond_to?(:to_hash)
          pairs = msg.to_hash.map { |k, v| format_pair(k, v) }
          pairs.compact.join(" ")
        else
          format_pair("msg", msg)
        end
      end

      def format_pair(key, value)
        return nil if value.nil?

        # Return a bare key when the value is a `TrueClass`
        return key if value == true

        "#{key}=#{format_value(value)}"
      end

      def format_progname(progname)
        return nil unless progname

        # Format this pair like any other to ensure quoting, escaping, etc…,
        # But we also need a leading space so we can interpolate the resulting
        # key/value pair into our log line.
        " #{format_pair(" progname", progname)}"
      end

      def format_value(value)
        if value.is_a?(Float)
          format("%.3f", value)
        elsif value.is_a?(Time)
          format_datetime(value)
        elsif value.respond_to?(:to_ary)
          format_value(
            "[#{Array(value).map { |v| format_value(v) }.join(", ")}]"
          )
        else
          # Interpolating due to a weird/subtle behaviour possible in #to_s.
          # Namely, it's possible it doesn't actually return a String:
          # https://github.com/ruby/spec/blob/3affe1e54fcd11918a242ad5d4a7ba895ee30c4c/language/string_spec.rb#L130-L141
          value = "#{value}" # rubocop:disable Style/RedundantInterpolation
          value = value.dump if value.match?(/[[:space:]]|[[:cntrl:]]/) # wrap in quotes and escape control characters
          value
        end
      end
    end
  end
end
