# frozen_string_literal: true

require "logfmt/logger"
require "active_support"

module Logfmt
  class TaggedLogger < ActiveSupport::Logger
    include ActiveSupport::TaggedLogging

    def initialize(*args, formatter: KeyValueFormatter.new, **kwargs)
      super
      
      # Wrap the base formatter in our tagging-aware formatter
      self.formatter = Formatter.new(self.formatter)
    end

    class Formatter < SimpleDelegator
      include ActiveSupport::TaggedLogging::Formatter

      def call(severity, timestamp, progname, msg)
        tag_pairs, bare_tags = current_tags.partition { |t| t.respond_to?(:to_hash) }

        pairs = {tags: format_bare_tags(bare_tags)}
        pairs = tag_pairs.map(&:to_hash)
          .inject(pairs, :merge)
          .merge(message_to_hash(msg))
          .compact

        __getobj__.call(severity, timestamp, progname, pairs)
      end

      private

      def format_bare_tags(tags)
        tags = Array(tags).compact

        return nil if tags.empty?

        tags.map { |tag| "[#{tag}]" }.join(" ")
      end

      def message_to_hash(message)
        return message.to_hash if message.respond_to?(:to_hash)

        {msg: message}
      end
    end
  end
end
